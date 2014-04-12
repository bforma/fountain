module Fountain
  module EventSourcing
    module AggregateRoot
      extend ActiveSupport::Concern
      include Fountain::Domain::AggregateRoot
      include Member

      module ClassMethods
        # @param [Enumerable] stream
        # @return [AggregateRoot]
        def new_from_stream(stream)
          aggregate = allocate
          aggregate.initialize_from_stream(stream)
          aggregate
        end
      end

      # @return [Object]
      attr_reader :id

      # @return [Integer]
      def version
        journal.last_committed_sequence_number
      end

      # @api private
      # @param [Enumerable] stream
      # @return [void]
      def initialize_from_stream(stream)
        if uncommitted_event_count > 0
          raise InvalidStateError, 'Aggregate has already been initialized'
        end

        last_sequence_number = nil

        stream.each do |event|
          last_sequence_number = event.sequence_number
          handle_recursively(event)
        end

        initialize_sequence_number(last_sequence_number)
      end

      # @private
      # @param [Object] payload
      # @param [Hash] headers
      # @return [void]
      def apply(payload, headers = {})
        handle_recursively(register_event(payload, headers))
      end

      private

      # @param [Fountain::Domain::EventEnvelope] event
      # @return [void]
      def handle_recursively(event)
        handle(event)

        child_entities.each do |entity|
          entity.aggregate_root = self
          entity.handle_aggregate_event(event)
        end
      end
    end # AggregateRoot
  end # EventSourcing
end
