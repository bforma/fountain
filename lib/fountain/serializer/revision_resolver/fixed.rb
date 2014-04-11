module Fountain
  module Serializer
    class FixedRevisionResolver
      # @param [String] revision
      def initialize(revision)
        @revision = revision
      end

      # @param [Class] klass
      # @return [String]
      def call(klass)
        @revision
      end
    end # FixedRevisionResoler
  end # Serializer
end
