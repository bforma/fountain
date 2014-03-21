module Fountain
  module Session
    class UnitListenerList
      include Enumerable
      include Loggable

      def initialize
        @listeners = []
      end

      # @yield [UnitListener]
      # @return [Enumerator]
      def each(&block)
        @listeners.each(&block)
      end

      # @param [UnitListener] listener
      # @return [void]
      def push(listener)
        logger.debug "Registered listener [#{listener.class.name}]"
        @listeners.push(listener)
      end

      # @param [Unit] unit
      # @param [Envelope] event
      # @return [Envelope]
      def on_event_registered(unit, event)
        @listeners.each do |listener|
          event = listener.on_event_registered(unit, event)
        end

        event
      end

      # @param [Unit] unit
      # @param [Enumerable] aggregates
      # @param [Enumerable] events
      # @return [void]
      def on_prepare_commit(unit, aggregates, events)
        @listeners.each do |listener|
          logger.debug "Notifying [#{listener.class.name}] that unit is preparing for commit"
          listener.on_prepare_commit(unit, aggregates, events)
        end
      end

      # @param [Unit] unit
      # @param [Object] transaction
      # @return [void]
      def on_prepare_transaction_commit(unit, transaction)
        @listeners.each do |listener|
          logger.debug "Notifying [#{listener.class.name}] that unit is preparing for transaction commit"
          listener.on_prepare_transaction_commit(unit, transaction)
        end
      end

      # @param [Unit] unit
      # @return [void]
      def after_commit(unit)
        @listeners.reverse_each do |listener|
          logger.debug "Notifying [#{listener.class.name}] that unit has been committed"
          listener.after_commit(unit)
        end
      end

      # @param [Unit] unit
      # @param [Throwable] cause
      # @return [void]
      def on_rollback(unit, cause = nil)
        @listeners.reverse_each do |listener|
          logger.debug "Notifying [#{listener.class.name}] that unit is rolling back"
          listener.on_rollback(unit, cause)
        end
      end

      # @param [UnitOfWork] unit
      # @return [void]
      def on_cleanup(unit)
        @listeners.reverse_each do |listener|
          logger.debug "Notifying [#{listener.class.name}] that unit is cleaning up"

          begin
            listener.on_cleanup(unit)
          rescue => error
            logger.warn "Listener [#{listener.class.name}] raised exception during cleanup"
            logger.warn error
          end
        end
      end
    end # UnitListenerList
  end # Session
end
