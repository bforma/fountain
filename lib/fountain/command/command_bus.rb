module Fountain
  module Command
    class CommandBus
      include AbstractType

      # @param [Envelope] command
      # @param [CommandCallback] callback
      # @return [void]
      abstract_method :dispatch

      # @param [Class] command_type
      # @param [Object] handler
      # @return [void]
      abstract_method :subscribe

      # @param [Class] command_type
      # @param [Object] handler
      # @return [Boolean] Returns true if handler was subscribed
      abstract_method :unsubscribe
    end # CommandBus
  end # Command
end
