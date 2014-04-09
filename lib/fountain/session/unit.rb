module Fountain
  module Session
    class Unit
      include Loggable

      STATE_NEW = 0
      STATE_READY = 1
      STATE_COMMITTED = 2

      # @param [TransactionManager] transaction_manager
      # @return [Unit]
      def self.start(transaction_manager = nil)
        unit = new(transaction_manager)
        unit.start

        unit
      end

      # @param [TransactionManager] transaction_manager
      def initialize(transaction_manager = nil)
        @inner_units = []
        @listeners = UnitListenerList.new
        @state = STATE_NEW
        @transaction_manager = transaction_manager

        @aggregates = AggregateTracker.new
        @events = EventTracker.new

        @resources = {}
        @inherited_resources = {}
      end

      # @return [Boolean]
      def started?
        @state > STATE_NEW
      end

      # @return [Boolean]
      def transactional?
        @transaction_manager
      end

      # @!group Lifecycle management

      # @raise [InvalidStateError]
      # @return [void]
      def start
        assert_new
        logger.debug 'Starting unit of work'

        perform_start

        if UnitStack.active?
          # This unit is nested
          @outer_unit = UnitStack.current
          @outer_unit.attach_inherited_resources(self)
          @outer_unit.register_inner_unit(self)
        end

        logger.debug 'Registering unit as active unit'
        UnitStack.push(self)

        @state = STATE_READY
      end

      # @raise [InvalidStateError]
      # @return [void]
      def commit
        assert_started

        begin
          @listeners.on_prepare_commit(self, @aggregates, @events)
          @aggregates.save
          @state = STATE_COMMITTED

          if @outer_unit
            logger.debug 'Unit is nested, commit will be finalized by outer unit'
          else
            logger.debug 'Unit is not nested, committing immediately'

            perform_commit
            stop
            perform_cleanup
          end
        rescue => error
          logger.debug 'Error occurred during commit, performing rollback'

          perform_rollback(error)
          stop
          perform_cleanup unless @outer_unit

          raise
        ensure
          logger.debug 'Clearing resources for unit'
          clear
        end
      end

      # @param [Throwable] cause
      # @return [void]
      def rollback(cause = nil)
        if cause
          logger.debug 'Rollback requested for unit of work due to error'
          logger.debug cause
        else
          logger.debug 'Rollback requested for unit of work for unknown reason'
        end

        if started?
          @inner_units.each do |unit|
            UnitStack.push(unit)
            unit.rollback(cause)
          end

          perform_rollback(cause)
        end
      ensure
        perform_cleanup unless @outer_unit
        clear
        stop
      end

      # @!endgroup

      # @param [UnitListener] listener
      # @return [void]
      def register_listener(listener)
        @listeners.push(listener)
      end

      # @param [Fountain::Domain::AggregateRoot] aggregate
      # @param [Fountain::Event::EventBus] event_bus
      # @param [Proc] callback
      # @return [void]
      def register_aggregate(aggregate, event_bus, callback)
        similar = @aggregates.find_similar(aggregate)
        if similar
          logger.info "Ignoring similar aggregate registration for [#{aggregate.class.name}] [#{aggregate.id}]"
          return similar
        end

        aggregate.add_event_callback do |event|
          register_for_publication(event, event_bus, true)
        end

        @aggregates.track(aggregate, callback)
        aggregate
      end

      # @param [Envelope] event
      # @param [Fountain::Event::EventBus] event_bus
      # @return [void]
      def publish_event(event, event_bus)
        register_for_publication(event, event_bus, @state < COMMITTED)
      end

      # @!group Resource management

      # Attaches the given resource to this unit of work with the given name
      #
      # If another resource was already attached with the same name, it will be replaced. If the
      # resource is `inherited`, it will be automatically attached to any nested units of work.
      #
      # @param [String] name
      # @param [Object] resource
      # @param [Boolean] inherited
      def attach_resource(name, resource, inherited = false)
        @resources[name] = resource
        if inherited
          @inherited_resources[name] = resource
        else
          @inherited_resources.delete(name)
        end
      end

      # Returns a previously attached resource by the given name
      #
      # @param [String] name
      # @return [Object] Returns nil if resource not attached
      def resource(name)
        @resources[name]
      end

      # Attaches all inherited resources to the given unit of work
      # @param [Unit] unit
      def attach_inherited_resources(unit)
        @inherited_resources.each do |name, resource|
          unit.attach_resource(name, resource, true)
        end
      end

      # @!endgroup

      # @api private
      # @param [Unit] unit
      # @return [void]
      def register_inner_unit(unit)
        @inner_units.push(unit)
      end

      # Performs the logic necessary to finalize the commit of this nested unit of work
      #
      # @api private
      # @return [void]
      def perform_inner_commit
        logger.debug 'Finalizing commit of nested unit of work'
        UnitStack.push(self)

        begin
          perform_commit
        rescue => error
          perform_rollback(error)
          raise
        ensure
          clear
          stop
        end
      end

      # Performs the logic necessary to commit this unit of work
      #
      # @api private
      # @return [void]
      def perform_commit
        loop do
          @events.publish
          commit_inner_units
          break if @events.empty?
        end

        if transactional?
          @listeners.on_prepare_transaction_commit(self, @transaction)
          @transaction_manager.commit(@transaction)
        end

        @listeners.after_commit(self)
      end

      # Performs the logic necessary to rollback this unit of work
      #
      # @api private
      # @param [Throwable] cause
      # @return [void]
      def perform_rollback(cause)
        @aggregates.clear
        @events.clear

        if @transaction
          @transaction_manager.rollback(@transaction)
        end
      ensure
        @listeners.on_rollback(self, cause)
      end

      # Performs the logic necessray to clean up this unit of work
      #
      # @api private
      # @return [void]
      def perform_cleanup
        @inner_units.each do |unit|
          unit.perform_cleanup
        end

        @listeners.on_cleanup(self)
      end

      private

      # Commits all registered inner units of work
      # @return [void]
      def commit_inner_units
        @inner_units.each do |unit|
          unit.perform_inner_commit if unit.started?
        end
      end

      # @param [Envelope] event
      # @param [Fountain::Event::EventBus] event_bus
      # @param [Boolean] notify_listeners
      # @return [Envelope] Final event that got registered
      def register_for_publication(event, event_bus, notify_listeners)
        if notify_listeners
          event = @listeners.on_event_registered(self, event)
        end

        @events.stage(event, event_bus)
        event
      end

      # Performs the logic necessary to start this unit of work
      # @return [void]
      def perform_start
        if @transaction_manager
          @transaction = @transaction_manager.start
        end
      end

      # Clears this unit of work from the unit stack
      # @return [void]
      def clear
        UnitStack.clear(self)
      end

      # Stops this unit of work
      # @return [void]
      def stop
        logger.debug 'Stopping unit of work'
        @state = STATE_NEW
      end

      # @raise [InvalidStateError]
      # @return [void]
      def assert_new
        raise InvalidStateError if @state > STATE_NEW
      end

      # @raise [InvalidStateError]
      # @return [void]
      def assert_started
        raise InvalidStateError unless @state > STATE_NEW
      end
    end # Unit
  end # Session
end
