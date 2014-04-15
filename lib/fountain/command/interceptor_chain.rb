module Fountain
  module Command
    class InterceptorChain
      # @param [Fountain::Session::Unit] unit
      # @param [Enumerable] interceptors
      # @param [Object] handler
      def initialize(unit, interceptors, handler)
        @unit = unit
        @interceptors = interceptors
        @handler = handler
      end

      # @param [Envelope] command
      # @return [Object]
      def proceed(command)
        @interceptors.next.intercept(command, @unit, self)
      rescue StopIteration
        @handler.call(command, @unit)
      end
    end # InterceptorChain
  end # Command
end
