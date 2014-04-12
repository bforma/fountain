module Fountain
  module Serializer
    class SerializedEventEnvelope < SerializedEnvelope
      # @return [Class]
      def self.builder_type
        SerializedEventEnvelopeBuilder
      end

      # @return [Integer]
      attr_reader :sequence_number

      # @param [String] id
      # @param [LazyObject] headers
      # @param [LazyObject] payload
      # @param [Time] timestamp
      # @param [Integer] sequence_number
      def initialize(id, headers, payload, timestamp, sequence_number)
        super(id, headers, payload, timestamp)
        @sequence_number = sequence_number
      end

      private

      # @param [SerializedEnvelopeBuilder] builder
      # @param [Hash] headers
      # @return [void]
      def populate_duplicate(builder, headers)
        super
        builder.sequence_number = @sequence_number
      end
    end # SerializedEventEnvelope
  end # Serializer
end
