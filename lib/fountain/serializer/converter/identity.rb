module Fountain
  module Serializer
    class IdentityConverter < Converter
      # @return [Class]
      attr_reader :source_type

      # @return [Class]
      attr_reader :target_type

      # @param [Class] type
      def initialize(type)
        @source_type = @target_type = type
      end

      # @param [SerializedObject] original
      # @return [SerializedObject]
      def convert(original)
        original
      end

      # @param [Object] original
      # @return [Object]
      def convert_content(original)
        original
      end
    end # IdentityConverter
  end # Serializer
end
