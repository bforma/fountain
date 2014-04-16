module Fountain
  module Event
    # Convenient mixin for adding routing to an event listener
    module Listener
      extend ActiveSupport::Concern

      included do
        # @return [Fountain::Router::EnvelopeRouter]
        inheritable_accessor :router do
          Router.create_router
        end
      end

      module ClassMethods
        # @see Fountain::Router::EnvelopeRouter#add_route
        def route(*args, &block)
          router.add_route(*args, &block)
        end
      end

      # @param [Envelope] event
      # @return [Object] Result from the listener
      def call(event)
        router.route_all(self, event)
      end
    end # Listener
  end # Event
end
