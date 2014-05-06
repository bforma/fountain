module Fountain
  module Event
    # Represents a mechanism used to connect clusters on the event bus. Terminals are responsible
    # for delivering events, whether it is done locally or remotely.
    class EventBusTerminal
      include AbstractType

      # Publishes the given events to all clusters known by the terminal
      #
      # @param [Envelope...] events
      # @return [void]
      abstract_method :publish

      # Called when a cluster was selected that was previously unknown to this terminal
      #
      # @param [Cluster] cluster
      # @return [void]
      abstract_method :on_cluster_creation
    end # EventBusTerminal
  end # Event
end
