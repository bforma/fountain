module Fountain
  module Event
    class ClusteringEventBus
      include ListenerProxyAware
      include Loggable

      # @param [Object] cluster_selector
      # @param [EventBusTerminal] terminal
      def initialize(cluster_selector, terminal)
        @cluster_selector = cluster_selector
        @terminal = terminal

        @clusters = ConcurrentSet.new
      end

      # @param [Envelope...] events
      # @return [void]
      def publish(*events)
        @terminal.publish(*events)
      end

      # @raise [SubscriptionError]
      # @param [Object] listener
      # @return [void]
      def subscribe(listener)
        cluster_for(listener).subscribe(listener)
      end

      # @param [Object] listener
      # @return [void]
      def unsubscribe(listener)
        cluster_for(listener).unsubscribe(listener)
      end

      private

      # @raise [SubscriptionError]
      # @param [Object] listener
      # @return [Cluster]
      def cluster_for(listener)
        listener_type = resolve_listener_type(listener)
        cluster = @cluster_selector.call(listener)

        unless cluster
          raise SubscriptionError, "No cluster selected for listener [#{listener_type}]"
        end

        logger.debug "Cluster [#{cluster.name}] selected for listener [#{listener_type}]"

        if @clusters.add?(cluster)
          logger.debug "Cluster [#{cluster.name}] now known to the terminal"
          @terminal.on_cluster_creation(cluster)
        end

        cluster
      end
    end # ClusteringEventBus
  end # Event
end
