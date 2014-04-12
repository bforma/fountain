module Fountain
  module Serializer
    # Decorator that provides convenience methods for optimized serialization of envelopes
    class EnvelopeSerializer
      extend Forwardable

      # @param [Serializer] serializer
      def initialize(serializer)
        @serializer = serializer
      end

      # @param [Envelope] envelope
      # @param [Class] representation_type
      # @return [SerializedObject]
      def serialize_headers(envelope, representation_type)
        if envelope.respond_to?(:serialize_headers)
          envelope.serialize_headers(@serializer, representation_type)
        else
          serialize(envelope.headers, representation_type)
        end
      end

      # @param [Envelope] envelope
      # @param [Class] representation_type
      # @return [SerializedObject]
      def serialize_payload(envelope, representation_type)
        if envelope.respond_to?(:serialize_payload)
          envelope.serialize_payload(@serializer, representation_type)
        else
          serialize(envelope.payload, representation_type)
        end
      end

      # Delegate public serializer methods
      def_delegators :@serializer, :converter_factory, :serialize, :deserialize,
        :can_serialize_to?, :class_for, :type_for
    end # EnvelopeSerializer
  end # Serializer
end
