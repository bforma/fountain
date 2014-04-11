module Fountain
  module Serializer
    class SerializedType
      include Adamantium
      include Equalizer.new(:name, :revision)

      # @param [String] name
      attr_reader :name

      # @param [String] revision
      attr_reader :revision

      # @param [String] name
      # @param [String] revision
      def initialize(name, revision = nil)
        @name = name
        @revision = revision.to_s
      end
    end # SerializedType
  end # Serializer
end
