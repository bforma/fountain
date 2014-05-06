module Fountain
  module Event
    # Container that stores the metadata for an event listener cluster
    #
    # This implementation provides two important characteristics, indifferent access and
    # thread-safe operations.
    class ClusterMetadata
      def initialize
        @properties = ThreadSafe::Cache.new
      end

      # @param [Symbol] key
      # @return [void]
      def delete(key)
        @properties.delete(normalize_key(key))
      end

      # @param [Symbol] key
      # @return [Object]
      def get(key)
        @properties[normalize_key(key)]
      end

      # @param [Symbol] key
      # @return [Boolean]
      def key?(key)
        @properties.key?(normalize_key(key))
      end

      # @param [Symbol] key
      # @param [Object] value
      # @return [void]
      def set(key, value)
        @properties[normalize_key(key)] = value
      end

      # @return [Hash]
      def to_hash
        hash = {}
        @properties.each_pair do |k, v|
          hash[k] = v
        end

        hash
      end

      private

      # @param [Object] key
      # @return [Symbol]
      def normalize_key(key)
        key.to_sym
      end
    end # ClusterMetadata
  end # Event
end
