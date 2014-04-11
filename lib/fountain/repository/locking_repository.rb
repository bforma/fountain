module Fountain
  module Repository
    class LockingRepository < BaseRepository
      # @return [LockManager]
      attr_reader :lock_manager

      # @param [Class] aggregate_type
      # @param [LockManager] lock_manager
      def initialize(aggregate_type, lock_manager)
        super(aggregate_type)
        @lock_manager = lock_manager
      end

      # @param [Fountain::Domain::AggregateRoot] aggregate
      # @return [void]
      def add(aggregate)
        aggregate_id = aggregate.id

        @lock_manager.obtain_lock(aggregate_id)
        begin
          super
          current_unit.register_listener(LockReleaseListener.new(@lock_manager, aggregate_id))
        rescue
          logger.debug 'Error occured while trying to add aggregate, releasing lock'
          @lock_manager.release_lock(aggregate_id)
          raise
        end
      end

      # @raise [AggregateNotFoundError] If aggregate not found
      # @raise [ConflictingAggregateVersionError]
      # @param [Object] aggregate_id
      # @param [Integer] expected_version
      # @return [Fountain::Domain::AggregateRoot]
      def load(aggregate_id, expected_version = nil)
        @lock_manager.obtain_lock(aggregate_id)
        begin
          aggregate = super
          current_unit.register_listener(LockReleaseListener.new(@lock_manager, aggregate_id))
          aggregate
        rescue
          logger.debug 'Error occured while trying to load aggregate, releasing lock'
          @lock_manager.release_lock(aggregate_id)
          raise
        end
      end

      private

      # @param [Fountain::Domain::AggregateRoot] aggregate
      # @return [void]
      def commit_aggregate(aggregate)
        unless @lock_manager.validate_lock(aggregate)
          raise ConcurrencyError, "Lock for [#{aggregate.class.name}] [#{aggregate.id}] was invalidated"
        end

        super(aggregate)
      end
    end # LockingRepository
  end # Repository
end
