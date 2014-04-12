module Fountain
  module Serializer
    class SerializedEnvelope
      # @yield [SerializedEnvelopeBuilder]
      # @return [SerializedEnvelope]
      def self.build(&block)
        builder_type.build(&block)
      end

      # @return [Class]
      def self.builder_type
        SerializedEnvelopeBuilder
      end

      # @return [String]
      attr_reader :id

      # @return [LazyObject]
      attr_reader :serialized_headers

      # @return [LazyObject]
      attr_reader :serialized_payload

      # @return [Time]
      attr_reader :timestamp

      # @param [String] id
      # @param [LazyObject] headers
      # @param [LazyObject] payload
      # @param [Time] timestamp
      def initialize(id, headers, payload, timestamp)
        @id = id
        @serialized_headers = headers
        @serialized_payload = payload
        @timestamp = timestamp
      end

      # @return [Hash]
      def headers
        @serialized_headers.deserialized
      end

      # @return [Object]
      def payload
        @serialized_payload.deserialized
      end

      # @return [Class]
      def payload_type
        @serialized_payload.type
      end

      # @param [Hash] headers
      # @return [SerializedEnvelope]
      def and_headers(headers)
        return self if headers.empty?
        build_duplicate(self.headers.merge(headers))
      end

      # @param [Hash] headers
      # @return [SerializedEnvelope]
      def with_headers(headers)
        return self if self.headers == headers
        build_duplicate(headers)
      end

      # @param [Serializer] serializer
      # @param [Class] expected_type
      # @return [SerializedObject]
      def serialize_headers(serializer, expected_type)
        serialize(@serialized_headers, serializer, expected_type)
      end

      # @param [Serializer] serializer
      # @param [Class] expected_type
      # @return [SerializedObject]
      def serialize_payload(serializer, expected_type)
        serialize(@serialized_payload, serializer, expected_type)
      end

      # @return [Class]
      def builder_type
        self.class.builder_type
      end

      private

      # @param [Hash] headers
      # @return [SerializedEnvelope]
      def build_duplicate(headers)
        builder = builder_type.new
        populate_duplicate(builder, headers)
        builder.build
      end

      # @param [SerializedEnvelopeBuilder] builder
      # @param [Hash] headers
      # @return [void]
      def populate_duplicate(builder, headers)
        builder.id = @id
        builder.headers = DeserializedObject.new(headers)
        builder.payload = @serialized_payload
        builder.timestamp = @timestamp
      end

      # @param [LazyObject] object
      # @param [Serializer] serializer
      # @param [Class] expected_type
      # @return [SerializedObject]
      def serialize(object, serializer, expected_type)
        if object.serializer == serializer
          serializer.converter_factory.convert(object.serialized_object, expected_type)
        else
          serializer.serialize(object.deserialized, expected_type)
        end
      end
    end # SerializedEnvelope
  end # Serializer
end
