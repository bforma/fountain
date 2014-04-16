module Fountain
  module Command
    class SerializationOptimizingInterceptor
      def initialize
        @listener = SerializationOptimizingListener.new
      end

      # @param [InterceptorChain] chain
      # @param [Envelope] command
      # @param [Fountain::Session::Unit] unit
      # @return [Object]
      def call(chain, command, unit)
        unit.register_listener(@listener)
        chain.proceed(command)
      end
    end # SerializationOptimizingInterceptor

    class SerializationOptimizingListener < Session::UnitListener
      # @param [Fountain::Session::Unit] unit
      # @param [Envelope] event
      # @return [Envelope]
      def on_event_registered(unit, event)
        if event.is_a?(Domain::EventEnvelope)
          Serializer::SerializationAwareEventEnvelope.decorate(event)
        else
          Serializer::SerializationAwareEnvelope.decorate(event)
        end
      end
    end # SerializationOptimizingListener
  end # Command
end
