module Fountain
  module Event
    # @abstract
    class EventBus
      # @abstract
      # @param [Envelope...] events
      # @return [void]
      def publish(*events)
        # This method is intentionally left blank
      end

      # @abstract
      # @raise [SubscriptionError] If subscription failed for listener
      # @param [Object] listener
      # @return [void]
      def subscribe(listener)
        # This method is intentionally left blank
      end

      # @abstract
      # @param [Object] listener
      # @return [void]
      def unsubscribe(listener)
        # This method is intentionally left blank
      end
    end # EventBus
  end # Event
end
