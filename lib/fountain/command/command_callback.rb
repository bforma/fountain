module Fountain
  module Command
    class CommandCallback
      # @param [Object] result
      # @return [void]
      def on_success(result)
        # This method is intentionally left blank
      end

      # @param [Exception] cause
      # @return [void]
      def on_failure(cause)
        # This method is intentionally left blank
      end
    end # CommandCallback
  end # Command
end
