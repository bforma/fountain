module Fountain
  module Event
    class EventBus
      include AbstractType

      # @param [Envelope...] events
      # @return [void]
      abstract_method :publish

      # @raise [SubscriptionError] If subscription failed for listener
      # @param [Object] listener
      # @return [void]
      abstract_method :subscribe

      # @param [Object] listener
      # @return [void]
      abstract_method :unsubscribe
    end # EventBus
  end # Event
end
