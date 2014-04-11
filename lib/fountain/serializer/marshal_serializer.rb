require 'base64'

module Fountain
  module Serializer
    class MarshalSerializer < BaseSerializer
      # This serializer doesn't provide any configuration options

      private

      # @param [Object] object
      # @return [Object]
      def perform_serialize(object)
        Base64.encode64(Marshal.dump(object))
      end

      # @param [Object] content
      # @param [Class] type
      # @return [Object]
      def perform_deserialize(content, type)
        Marshal.load(Base64.decode64(content))
      end

      # @return [Class]
      def native_content_type
        String
      end
    end # MarshalSerializer
  end # Serializer
end
