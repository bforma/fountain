module Fountain
  module Repository
    class LockManager
      # @param [AggregateRoot] aggregate
      # @return [Boolean]
      def validate_lock(aggregate)
        true
      end

      # @param [Object] aggregate_id
      # @return [void]
      def obtain_lock(aggregate_id)
        # This method is intentionally left blank
      end

      # @param [Object] aggregate_id
      # @return [void]
      def release_lock(aggregate_id)
        # This method is intentionally left blank
      end
    end # LockManager
  end # Repository
end
