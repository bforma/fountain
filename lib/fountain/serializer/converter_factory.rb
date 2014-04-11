module Fountain
  module Serializer
    # Represents a mechanism for storing and retrieving converters capable of converting content
    # of one type to another type, for the purpose of serialization and upcasting.
    class ConverterFactory
      def initialize
        @converters = ConcurrentSet.new
      end

      # @param [Converter] converter
      # @return [void]
      def register(converter)
        @converters.add(converter)
      end

      # Convenience method for converting a given serialized object to the given target type
      #
      # @param [SerializedObject] serialized_object
      # @param [Class] target_type
      # @return [SerializedObject]
      def convert(serialized_object, target_type)
        converter(serialized_object.content_type, target_type).convert(serialized_object)
      end

      # Returns a converter that is capable of converting content of the given source type to
      # the given target type, if one exists.
      #
      # @raise [ConversionError] If no converter is capable of performing the conversion
      # @param [Class] source_type
      # @param [Class] target_type
      # @return [Converter]
      def converter(source_type, target_type)
        if source_type == target_type
          converter = IdentityConverter.new(source_type)
        else
          converter = @converters.find do |converter|
            converter.can_convert?(source_type, target_type)
          end
        end

        unless converter
          raise ConversionError, "No converter capable of [#{source_type}] -> [#{target_type}]"
        end

        converter
      end

      # Returns true if this factory can provide a converter capable of converting content from the
      # given source type to the given target type.
      #
      # @param [Class] source_type
      # @param [Class] target_type
      # @return [Boolean]
      def has_converter?(source_type, target_type)
        if source_type == target_type
          true
        else
          @converters.any? do |converter|
            converter.can_convert?(source_type, target_type)
          end
        end
      end
    end # ConverterFactory
  end # Serializer
end
