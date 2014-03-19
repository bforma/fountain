module Fountain
  module Domain
    class EventEnvelopeBuilder < EnvelopeBuilder
      # @return [Integer]
      attr_accessor :sequence_number

      # @return [EventEnvelope]
      def build
        EventEnvelope.new(id, headers, payload, timestamp, sequence_number)
      end
    end # EventEnvelopeBuilder
  end # Domain
end
