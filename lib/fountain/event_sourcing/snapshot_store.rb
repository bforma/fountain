module Fountain
  module EventSourcing
    class SnapshotStore
      include AbstractType

      # @param [String] type_identifier
      # @param [Object] aggregate_id
      # @return [AggregateRoot]
      abstract_method :load

      # @param [String] type_identifier
      # @param [AggregateRoot] aggregate
      # @return [void]
      abstract_method :store
    end # SnapshotStore
  end # EventSourcing
end
