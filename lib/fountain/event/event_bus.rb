module Fountain
  module Event
    # @abstract
    class EventBus
      # @abstract
      # @param [Envelope...] events
      def publish(*events)
        # This method is intentionally left blank
      end

      # @abstract
      # @raise [SubscriptionError] If subscription failed for listener
      # @param [EventListener] listener
      def subscribe(listener)
        # This method is intentionally left blank
      end

      # @abstract
      # @param [EventListener] listener
      def unsubscribe(listener)
        # This method is intentionally left blank
      end
    end # EventBus
  end # Event
end
