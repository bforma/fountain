module Fountain
  module Serializer
    class SerializedEventEnvelopeBuilder < SerializedEnvelopeBuilder
      # @return [Integer]
      attr_accessor :sequence_number

      # @return [SerializedEventEnvelope]
      def build
        SerializedEventEnvelope.new(id, headers, payload, timestamp, sequence_number)
      end
    end # SerializedEventEnvelopeBuilder
  end # Serializer
end

