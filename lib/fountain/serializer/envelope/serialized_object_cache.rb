module Fountain
  module Serializer
    # Thread-safe cache for envelopes to store serialized headers and payload
    # @api private
    class SerializedObjectCache
      # @param [Envelope] envelope
      # @return [undefined]
      def initialize(envelope)
        @envelope = envelope

        @headers_cache = ThreadSafe::Cache.new
        @payload_cache = ThreadSafe::Cache.new
      end

      # @param [Serializer] serializer
      # @param [Class] expected_type
      # @return [SerializedObject]
      def serialize_headers(serializer, expected_type)
        serialize(@envelope.headers, @headers_cache, serializer, expected_type)
      end

      # @param [Serializer] serializer
      # @param [Class] expected_type
      # @return [SerializedObject]
      def serialize_payload(serializer, expected_type)
        serialize(@envelope.payload, @payload_cache, serializer, expected_type)
      end

      private

      # @param [Object] object
      # @param [ThreadSafe::Cache] cache
      # @param [Serializer] serializer
      # @param [Class] expected_type
      # @return [SerializedObject]
      def serialize(object, cache, serializer, expected_type)
        serialized = cache.compute_if_absent(serializer) do
          serializer.serialize(object, expected_type)
        end

        serializer.converter_factory.convert(serialized, expected_type)
      end
    end # SerializedObjectCache
  end # Serializer
end
