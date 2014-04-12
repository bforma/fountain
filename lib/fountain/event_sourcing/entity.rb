module Fountain
  module EventSourcing
    module Entity
      extend ActiveSupport::Concern
      include Member

      # @return [AggregateRoot]
      attr_reader :aggregate_root

      # @raise [InvalidStateError]
      # @param [AggregateRoot] aggregate_root
      # @return [void]
      def aggregate_root=(aggregate_root)
        if @aggregate_root && !@aggregate_root.equal?(aggregate_root)
          raise InvalidStateError, 'Entity already registered to an aggregate root'
        end

        @aggregate_root = aggregate_root
      end

      # Handles the given event and recurses to any child entities
      #
      # @param [Fountain::Domain::EventEnvelope] event
      # @return [void]
      def handle_aggregate_event(event)
        handle(event)

        child_entities.each do |entity|
          entity.aggregate_root = @aggregate_root
          entity.handle_aggregate_event(event)
        end
      end

      private

      # Applies the given event to the aggregate root
      #
      # @param [Object] payload
      # @param [Hash] headers
      # @return [void]
      def apply(payload, headers = {})
        @aggregate_root.apply(payload, headers)
      end
    end # Entity
  end # EventSourcing
end
