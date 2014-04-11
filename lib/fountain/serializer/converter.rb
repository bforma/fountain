module Fountain
  module Serializer
    class Converter
      # @param [Class] source_type
      # @param [Class] target_type
      # @return [Boolean]
      def can_convert?(source_type, target_type)
        self.source_type == source_type && self.target_type == target_type
      end

      # @param [SerializedObject] original
      # @return [SerializedObject]
      def convert(original)
        SerializedObject.new(convert_content(original.content), target_type, original.type)
      end

      # @param [Object] original
      # @return [Object]
      def convert_content(original)
        raise NotImplementedError
      end

      # @return [Class]
      def source_type
        raise NotImplementedError
      end

      # @return [Class]
      def target_type
        raise NotImplementedError
      end
    end # Converter
  end # Serializer
end
