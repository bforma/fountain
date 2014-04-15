module Fountain
  module Command
    # Convenient mixin for adding routing to a command handler
    module Handler
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

      # @param [Envelope] command
      # @param [Fountain::Session::Unit] current_unit
      # @return [Object] Result from the handler
      def call(command, current_unit)
        router.route_first!(self, command)
      end
    end # Handler
  end # Command
end
