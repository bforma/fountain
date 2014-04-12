module Fountain
  module Serializer
    class SerializationAwareEnvelope
      extend Forwardable

      # @param [Envelope] envelope
      # @return [SerializationAwareEnvelope]
      def self.decorate(envelope)
        return envelope if envelope.is_a?(self)
        new(envelope)
      end

      # @param [Envelope] envelope
      def initialize(envelope)
        @envelope = envelope
        @cache = SerializedObjectCache.new(envelope)
      end

      # @param [Hash] headers
      # @return [SerializationAwareEnvelope]
      def and_headers(headers)
        envelope = @envelope.and_headers(headers)
        return self if @envelope == envelope

        self.class.new(envelope)
      end

      # @param [Hash] headers
      # @return [SerializationAwareEnvelope]
      def with_headers(headers)
        envelope = @envelope.with_headers(headers)
        return self if @envelope == envelope

        self.class.new(envelope)
      end

      # Delegators for the serialized object cache
      def_delegators :@cache, :serialize_headers, :serialize_payload

      # Delegators for envelope attributes
      def_delegators :@envelope, :id, :headers, :payload, :payload_type, :timestamp
    end # SerializationAwareEnvelope
  end # Serializer
end
