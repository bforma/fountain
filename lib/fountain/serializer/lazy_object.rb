module Fountain
  module Serializer
    # Generic container for a lazily-deserialized object
    class LazyObject
      # @return [SerializedObject]
      attr_reader :serialized_object

      # @return [Serializer]
      attr_reader :serializer

      # @return [Class]
      attr_reader :type

      # @param [SerializedObject] serialized_object
      # @param [Serializer] serializer
      def initialize(serialized_object, serializer)
        @serialized_object = serialized_object
        @serializer = serializer
        @type = serializer.class_for(serialized_object.type)
      end

      # @param [Object] deserialized
      def deserialized
        @deserialized ||= @serializer.deserialize(@serialized_object)
      end

      # @return [Boolean]
      def deserialized?
        !!@deserialized
      end
    end # LazyObject

    # Drop-in replacement for LazyObject when an object has already been deserialized
    class DeserializedObject
      # @return [Object]
      attr_reader :deserialized

      # @return [Serializer] Always returns nil
      attr_reader :serializer

      # @return [Class]
      attr_reader :type

      # @param [Object] deserialized
      def initialize(deserialized)
        @deserialized = deserialized
        @type = deserialized.class
      end

      # @return [Boolean] Always returns true
      def deserialized?
        true
      end
    end # DeserializedObject
  end # Serializer
end
