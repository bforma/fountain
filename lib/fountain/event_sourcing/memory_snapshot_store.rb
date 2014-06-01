module Fountain
  module EventSourcing
    class MemorySnapshotStore < SnapshotStore
      def initialize
        @snapshots = ThreadSafe::Cache.new
      end

      # @param [Object] aggregate_id
      # @return [AggregateRoot]
      def load(aggregate_id)
        snapshot = @snapshots.get(aggregate_id)
        Marshal.load(snapshot) if snapshot
      end

      # @param [AggregateRoot] aggregate
      # @return [void]
      def store(aggregate)
        if aggregate.uncommitted_event_count > 0
          raise ArgumentError, 'Aggregate has uncommitted events'
        end

        @snapshots.put(aggregate.id, Marshal.dump(aggregate))
      end
    end # MemorySnapshotStore
  end # EventSourcing
end
