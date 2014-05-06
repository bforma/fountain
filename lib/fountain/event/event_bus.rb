module Fountain
  module Event
    # Represents a mechanism for event listeners to subscribe to events and for event publishers
    # to dispatch their events to any interested parties.
    #
    # Implementations may or may not dispatch the events to listeners in the dispatching thread.
    class EventBus
      include AbstractType

      # Publishes one or more events to any listeners subscribed to this event bus
      #
      # Implementations may treat the given events as a single batch and distribute them as such
      # to all subscribed event listeners.
      #
      # @param [Envelope...] events
      # @return [void]
      abstract_method :publish

      # Subscribes the given listener to this event bus
      #
      # @raise [SubscriptionError] If subscription failed for listener
      # @param [Object] listener
      # @return [void]
      abstract_method :subscribe

      # Unsubscribes the given listener from this event bus
      #
      # @param [Object] listener
      # @return [void]
      abstract_method :unsubscribe
    end # EventBus
  end # Event
end
