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
      # @param [Object] listener
      def subscribe(listener)
        # This method is intentionally left blank
      end

      # @abstract
      # @param [Object] listener
      def unsubscribe(listener)
        # This method is intentionally left blank
      end
    end # EventBus
  end # Event
end
