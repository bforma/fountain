require 'active_support/core_ext/string/inflections'

module Fountain
  module Serializer
    # @abstract
    class BaseSerializer
      # @return [ConverterFactory]
      attr_reader :converter_factory

      # @return [Object]
      attr_accessor :revision_resolver

      # @param [ConverterFactory] converter_factory
      def initialize(converter_factory)
        @converter_factory = converter_factory
      end

      # @param [Object] object
      # @param [Class] representation_type
      # @return [SerializedObject]
      def serialize(object, representation_type)
        content = convert(perform_serialize(object), native_content_type, representation_type)
        type = type_for(object.class)

        SerializedObject.new(content, representation_type, type)
      end

      # @param [SerializedObject] serialized_object
      # @return [Object]
      def deserialize(serialized_object)
        content = convert(serialized_object.content, serialized_object.content_type, native_content_type)
        klass = class_for(serialized_object.type)

        perform_deserialize(content, klass)
      end

      # @param [Class] representation_type
      # @return [Boolean]
      def can_serialize_to?(representation_type)
        converter_factory.has_converter?(native_content_type, representation_type)
      end

      # @raise [UnknownSerializedTypeError]
      # @param [SerializedType] serialized_type
      # @return [Class]
      def class_for(serialized_type)
        serialized_type.name.constantize
      rescue NameError
        raise UnknownSerializedTypeError, "Unknown serialized type [#{serialized_type.name}]"
      end

      # @param [Class] klass
      # @return [SerializedType]
      def type_for(klass)
        if revision_resolver
          SerializedType.new(klass.name, revision_resolver.call(klass))
        else
          SerializedType.new(klass.name)
        end
      end

      private

      # Serializes the given Ruby object
      #
      # @abstract
      # @param [Object] object Original Ruby object to serializer
      # @return [Object] Serialized content having the native content type
      def perform_serialize(object)
        raise NotImplementedError
      end

      # Deserializes the given serialized content into the given Ruby type
      #
      # @abstract
      # @param [Object] content Serialized content having the native content type
      # @param [Class] klass Target class being deserialized
      # @return [Object] Deserialized object
      def perform_deserialize(content, klass)
        raise NotImplementedError
      end

      # Returns the native content type that this serializer uses
      #
      # @abstract
      # @return [Class]
      def native_content_type
        raise NotImplementedError
      end

      # Converts the given content from the given source type to the given target type
      #
      # @param [Object] original
      # @param [Class] source_type
      # @param [Class] target_type
      # @return [Object]
      def convert(original, source_type, target_type)
        converter_factory.converter(source_type, target_type).convert_content(original)
      end
    end # BaseSerializer
  end # Serializer
end
