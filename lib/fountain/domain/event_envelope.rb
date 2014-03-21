module Fountain
  module Domain
    class EventEnvelope < Envelope
      # @return [Class]
      def self.builder_type
        EventEnvelopeBuilder
      end

      # @return [Integer]
      attr_reader :sequence_number

      # @param [String] id
      # @param [Hash] headers
      # @param [Object] payload
      # @param [Time] timestamp
      # @param [Integer] sequence_number
      # @return [void]
      def initialize(id, headers, payload, timestamp, sequence_number)
        super(id, headers, payload, timestamp)
        @sequence_number = sequence_number
      end

      private

      # @param [EventEnvelopeBuilder] builder
      # @param [Hash] headers
      # @return [void]
      def populate_duplicate(builder, headers)
        super
        builder.sequence_number = @sequence_number
      end
    end # EventEnvelope
  end # Domain
end
