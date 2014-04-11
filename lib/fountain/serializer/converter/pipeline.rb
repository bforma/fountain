module Fountain
  module Serializer
    class PipelineConverter < Converter
      # @return [Class]
      attr_reader :source_type

      # @return [Class]
      attr_reader :target_type

      # @param [Enumerable] elements
      def initialize(elements)
        @elements = elements
        @source_type = elements.first.source_type
        @target_type = elements.last.source_type
      end

      # @param [SerializedObject] original
      # @return [SerializedObject]
      def convert(original)
        @elements.reduce(original) do |intermediate, element|
          element.convert(intermediate)
        end
      end

      # @param [Object] original
      # @return [Object]
      def convert_content(original)
        @elements.reduce(original) do |intermediate, element|
          element.convert_content(intermediate)
        end
      end
    end # PipelineConverter
  end # Serializer
end
