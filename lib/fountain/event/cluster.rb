module Fountain
  module Event
    # Represents a logical group of event listeners that are treated as a single unit by the
    # clustering event bus. Clusters are used to apply behavior to a group of listeners, such as
    # transaction management, asynchronous publishing and distribution.
    #
    # Note that listeners should not be directly subscribed to a cluster. Use the subscription
    # mechanism provided by the clustering event bus to ensure that a cluster is properly
    # recognized by the event bus.
    class Cluster
      include AbstractType

      # Publishes the given events to any members subscribed to this cluster
      #
      # @param [Envelope...] events
      # @return [void]
      abstract_method :publish

      # Subscribes an event listener to this cluster
      #
      # @param [Object] listener
      # @return [void]
      abstract_method :subscribe

      # Unsubscribes an event listener from this cluster
      #
      # @param [Object] listener
      # @return [void]
      abstract_method :unsubscribe

      # Returns the name of this cluster
      # @return [Enumerable]
      abstract_method :members

      # Returns a snapshot of the members of this cluster
      # @return [ClusterMetadata]
      abstract_method :metadata

      # Returns the metadata associated with this cluster
      # @return [String]
      abstract_method :name
    end # Cluster
  end # Event
end
