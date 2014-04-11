module Fountain
  module Serializer
    class SerializedObject
      include Adamantium
      include Equalizer.new(:content, :content_type, :type)

      # Convenience method for building a serialized object and type
      #
      # @param [Object] content
      # @param [Class] content_type
      # @param [String] name
      # @param [String] revision
      # @return [SerializedObject]
      def self.build(content, content_type, name, revision = nil)
        new(content, content_type, SerializedType.new(name, revision))
      end

      # @return [Object]
      attr_reader :content

      # @return [Class]
      attr_reader :content_type

      # @return [SerializedType]
      attr_reader :type

      # @param [Object] content
      # @param [Class] content_type
      # @param [SerializedType] type
      def initialize(content, content_type, type)
        @content = content
        @content_type = content_type
        @type = type
      end
    end # SerializedObject
  end # Serializer
end
