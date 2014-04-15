module Fountain
  module Command
    class InterceptorChain
      # @param [Fountain::Session::Unit] unit
      # @param [Array] interceptors
      # @param [Object] handler
      def initialize(unit, interceptors, handler)
        @unit = unit
        @interceptors = interceptors
        @handler = handler

        @index = -1
      end

      # @param [Envelope] command
      # @return [Object]
      def proceed(command)
        @index += 1
        if @interceptors[@index]
          @interceptors[@index].call(self, command, @unit)
        else
          @handler.call(command, @unit)
        end
      end
    end # InterceptorChain
  end # Command
end
