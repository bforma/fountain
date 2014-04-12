module Fountain
  module Serializer
    class SerializedEnvelopeBuilder
      # @yield [SerializedEnvelopeBuilder]
      # @return [SerializedEnvelope]
      def self.build
        builder = new
        yield builder if block_given?
        builder.build
      end

      # @return [String]
      attr_accessor :id

      # @return [LazyObject]
      attr_accessor :headers

      # @return [LazyObject]
      attr_accessor :payload

      # @return [Time]
      attr_accessor :timestamp

      # @return [SerializedEnvelope]
      def build
        SerializedEnvelope.new(id, headers, payload, timestamp)
      end

      # @param [SerializedObject] headers
      # @param [SerializedObject] payload
      # @param [Serializer] serializer
      # @return [void]
      def from_serialized(headers, payload, serializer)
        @headers = LazyObject.new(headers, serializer)
        @payload = LazyObject.new(payload, serializer)
      end
    end # SerializedEnvelopeBuilder
  end # Serializer
end
