module Fountain
  module Event
    class DefaultClusterSelector
      # @param [Cluster] cluster
      def initialize(cluster)
        @cluster = cluster
      end

      # @param [Object] listener
      # @return [Cluster]
      def call(listener)
        @cluster
      end
    end # DefaultClusterSelector
  end # Event
end
