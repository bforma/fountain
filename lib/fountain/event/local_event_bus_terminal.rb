module Fountain
  module Event
    # Implementation of an event bus terminal that publishes events locally
    class LocalEventBusTerminal < EventBusTerminal
      def initialize
        @clusters = ConcurrentList.new
      end

      # @param [Envelope...] events
      # @return [void]
      def publish(*events)
        @clusters.each do |cluster|
          cluster.publish(*events)
        end
      end

      # @param [Cluster] cluster
      # @return [void]
      def on_cluster_creation(cluster)
        @clusters.push(cluster)
      end
    end # LocalEventBusTerminal
  end # Event
end
