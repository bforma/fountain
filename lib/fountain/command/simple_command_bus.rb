module Fountain
  module Command
    class SimpleCommandBus < CommandBus
      # @return [ConcurrentList]
      attr_reader :filters

      # @return [ConcurrentList]
      attr_reader :interceptors

      # @return [Fountain::Session::UnitFactory]
      attr_accessor :unit_factory

      def initialize
        @filters = ConcurrentList.new
        @interceptors = ConcurrentList.new
        @subscriptions = ThreadSafe::Cache.new
        @unit_factory = Session::UnitFactory.new
      end

      # @param [Envelope] command
      # @param [CommandCallback] callback
      # @return [void]
      def dispatch(command, callback = CommandCallback.new)
        perform_dispatch(filter(command), callback)
      end

      # @param [Class] command_type
      # @param [Object] handler
      # @return [void]
      def subscribe(command_type, handler)
        @subscriptions[command_type] = handler
      end

      # @param [Class] command_type
      # @param [Object] handler
      # @return [Boolean] Returns true if handler was subscribed
      def unsubscribe(command_type, handler)
        @subscriptions.delete_pair(command_type, handler)
      end

      # @param [Fountain::Session::TransactionManager] value
      # @return [void]
      def transaction_manager=(value)
        @unit_factory = Session::UnitFactory.new(value)
      end

      private

      # @raise [NoHandlerError]
      # @param [Envelope] command
      # @param [CommandCallback] callback
      # @return [void]
      def perform_dispatch(command, callback)
        handler = handler_for(command)
        callback.on_success(dispatch_to(command, handler))
      rescue => error
        callback.on_failure(error)
      end

      # @param [Envelope] command
      # @param [Object] handler
      # @return [Object] The result of the command execution
      def dispatch_to(command, handler)
        unit = @unit_factory.call

        chain = InterceptorChain.new(unit, @interceptors.each, handler)
        result = chain.proceed(command)

        unit.commit
        result
      end

      # @param [Envelope] command
      # @return [Envelope] The command to be dispatched
      def filter(command)
        @filters.reduce(command) do |intermediate, filter|
          filter.call(intermediate)
        end
      end

      # @raise [NoHandlerError]
      # @param [Envelope] command
      # @return [Object]
      def handler_for(command)
        @subscriptions.fetch(command.payload_type)
      rescue KeyError
        raise NoHandlerError, "No handler subscribed for [#{command.payload_type}]"
      end
    end # SimpleCommandBus
  end # Command
end
