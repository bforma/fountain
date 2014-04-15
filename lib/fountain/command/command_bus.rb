module Fountain
  module Command
    # @abstract
    class CommandBus
      # @abstract
      # @param [Envelope] command
      # @param [CommandCallback] callback
      # @return [void]
      def dispatch(command, callback = CommandCallback.new)
        raise NotImplementedError
      end

      # @abstract
      # @param [Class] command_type
      # @param [Object] handler
      # @return [void]
      def subscribe(command_type, handler)
        raise NotImplementedError
      end

      # @abstract
      # @param [Class] command_type
      # @param [Object] handler
      # @return [Boolean] Returns true if handler was subscribed
      def unsubscribe(command_type, handler)
        raise NotImplementedError
      end
    end # CommandBus
  end # Command
end
