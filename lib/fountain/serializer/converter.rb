module Fountain
  module Serializer
    class Converter
      include AbstractType

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
      abstract_method :convert_content

      # @return [Class]
      abstract_method :source_type

      # @return [Class]
      abstract_method :target_type
    end # Converter
  end # Serializer
end
