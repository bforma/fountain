module Fountain
  module EventSourcing
    class MemorySnapshotStore < SnapshotStore
      SNAPSHOT_KEY_FORMAT = '%s:%s'

      def initialize
        @snapshots = ThreadSafe::Cache.new
      end

      # @param [String] type_identifier
      # @param [Object] aggregate_id
      # @return [AggregateRoot]
      def load(type_identifier, aggregate_id)
        snapshot = @snapshots.get(snapshot_key_for(type_identifier, aggregate_id))
        Marshal.load(snapshot) if snapshot
      end

      # @param [String] type_identifier
      # @param [AggregateRoot] aggregate
      # @return [void]
      def store(type_identifier, aggregate)
        if aggregate.uncommitted_event_count > 0
          raise ArgumentError, 'Aggregate has uncommitted events'
        end

        key = snapshot_key_for(type_identifier, aggregate.id)
        snapshot = Marshal.dump(aggregate)

        @snapshots.put(key, snapshot)
      end

      private

      # @param [String] type_identifier
      # @param [Object] aggregate_id
      # @return [String]
      def snapshot_key_for(type_identifier, aggregate_id)
        format(SNAPSHOT_KEY_FORMAT, type_identifier, aggregate_id)
      end
    end # MemorySnapshotStore
  end # EventSourcing
end
