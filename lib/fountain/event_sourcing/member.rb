module Fountain
  module EventSourcing
    module Member
      extend ActiveSupport::Concern

      included do
        # @return [Set]
        inheritable_accessor :child_fields do
          Set.new
        end

        # @return [Fountain::Router::EnvelopeRouter]
        inheritable_accessor :event_router do
          Router.create_router
        end
      end

      module ClassMethods
        # @param [Symbol...] names
        # @return [void]
        def child_entity(*names)
          names.each do |name|
            child_fields.add(name)
          end
        end

        alias_method :child_entities, :child_entity

        # @see Fountain::Router::EnvelopeRouter#route
        def route_event(*args, &block)
          event_router.add_route(*args, &block)
        end
      end

      # @param [Fountain::Domain::EventEnvelope] event
      # @return [void]
      def handle(event)
        event_router.route_all(self, event)
      end

      # Returns the children of this entity
      # @return [Enumerable]
      def child_entities
        child_fields.map { |field|
          value = instance_variable_get("@#{field}")

          if value.respond_to?(:handle_aggregate_event)
            value
          elsif value.response_to?(:each)
            value.to_enum.select do |v|
              v.respond_to?(:handle_aggregate_event)
            end
          end
        }.flatten.compact
      end
    end # Member
  end # EventSourcing
end
