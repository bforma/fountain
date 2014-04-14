module Fountain
  module EventSourcing
    class Repository < Fountain::Repository::LockingRepository
      # @param [Class] aggregate_type
      # @param [Fountain::EventStore::EventStore] event_store
      # @return [Repository]
      def self.build(aggregate_type, event_store)
        new(AggregateFactory.new(aggregate_type), event_store, Fountain::Repository::LockManager.new)
      end

      # @param [AggregateFactory] aggregate_factory
      # @param [Fountain::EventStore::EventStore] event_store
      # @param [Fountain::Repository::LockManager] lock_manager
      def initialize(aggregate_factory, event_store, lock_manager)
        super(aggregate_factory.aggregate_type, lock_manager)

        @aggregate_factory = aggregate_factory
        @event_store = event_store
      end

      private

      # @param [Object] aggregate_id
      # @param [Integer] expected_version
      # @return [AggregateRoot]
      def perform_load(aggregate_id, expected_version)
        stream_id = @aggregate_factory.stream_id(aggregate_id)
        begin
          events = @event_store.load_all(stream_id)
        rescue EventStore::StreamNotFoundError
          raise Fountain::Repository::AggregateNotFoundError.new(aggregate_type, aggregate_id)
        end

        aggregate = @aggregate_factory.create
        aggregate.initialize_from_stream(events)

        if aggregate.deleted?
          raise AggregateDeletedError.new(aggregate_type, aggregate_id)
        end

        aggregate
      end

      # @param [AggregateRoot] aggregate
      # @return [void]
      def perform_save(aggregate)
        stream = aggregate.uncommitted_events
        stream_id = @aggregate_factory.stream_id(aggregate.id)

        @event_store.append(stream_id, stream)
      end

      # @param [AggregateRoot] aggregate
      # @return [void]
      def perform_delete(aggregate)
        perform_save(aggregate)
      end
    end # Repository
  end # EventSourcing
end
