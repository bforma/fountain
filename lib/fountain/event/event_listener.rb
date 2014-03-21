module Fountain
  module Event
    # @abstract
    module EventListener
      # @abstract
      # @param [Envelope] event
      def notify(event)
        # This method is intentionally left blank
      end
    end # EventListener
  end # Event
end
