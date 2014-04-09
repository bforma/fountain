module Fountain
  module Repository
    # Base implementation of a repository that will dispatch any uncommitted events when an
    # aggregate is persisted
    #
    # Note that this repository does not handle locking. The underlying persistence mechanism must
    # deal with locking to use this repository (through optimistic locking or otherwise).
    class BaseRepository
      include Loggable

      # @return [Class]
      attr_reader :aggregate_type

      # @return [Fountain::Event::EventBus]
      attr_accessor :event_bus

      # @param [Class] aggregate_type
      def initialize(aggregate_type)
        @aggregate_type = aggregate_type
      end

      # @raise [ArgumentError] If aggregate does not match repository aggregate type
      # @raise [ArgumentError] If aggregate has version
      # @param [Fountain::Domain::AggregateRoot] aggregate
      # @return [void]
      def add(aggregate)
        unless aggregate.is_a?(aggregate_type)
          raise ArgumentError, 'Unsuitable aggregate type for repository'
        end

        if aggregate.version
          raise ArgumentError, 'Only new aggregates may be added to repository'
        end

        current_unit.register_aggregate(aggregate, event_bus, method(:commit_aggregate))
      end

      # @param [Object] aggregate_id
      # @param [Integer] expected_version
      # @return [Fountain::Domain::AggregateRoot]
      def load(aggregate_id, expected_version = nil)
        aggregate = perform_load(aggregate_id, expected_version)
        validate_version(aggregate, expected_version)
        current_unit.register_aggregate(aggregate, event_bus, method(:commit_aggregate))
      end

      private

      # Perform action after updating an aggregate and committing the event journal
      #
      # @param [Fountain::Domain::AggregateRoot] aggregate
      # @return [void]
      def post_save(aggregate)
        # This method is intentionally left blank
      end

      # Perform action after deleting an aggregate and committing the event journal
      #
      # @param [Fountain::Domain::AggregateRoot] aggregate
      # @return [void]
      def post_delete(aggregate)
        # This method is intentionally left blank
      end

      # @abstract
      # @param [Object] aggregate_id
      # @param [Integer] expected_version
      # @return [Fountain::Domain::AggregateRoot]
      def perform_load(aggregate_id, expected_version)
        raise NotImplementedError
      end

      # @abstract
      # @param [Fountain::Domain::AggregateRoot] aggregate
      # @return [void]
      def perform_save(aggregate)
        raise NotImplementedError
      end

      # @abstract
      # @param [Fountain::Domain::AggregateRoot] aggregate
      # @return [void]
      def perform_delete(aggregate)
        raise NotImplementedError
      end

      # @param [Fountain::Domain::AggregateRoot] aggregate
      # @return [void]
      def commit_aggregate(aggregate)
        if aggregate.deleted?
          perform_delete(aggregate)
        else
          perform_save(aggregate)
        end

        aggregate.commit_events

        if aggregate.deleted?
          post_delete(aggregate)
        else
          post_save(aggregate)
        end
      end

      # @raise [ConflictingAggregateVersionError]
      # @param [Fountain::Domain::AggregateRoot] aggregate
      # @param [Integer] expected_version
      # @return [void]
      def validate_version(aggregate, expected_version)
        unless expected_version.nil? || aggregate.version == expected_version
          raise ConflictingAggregateVersionError
        end
      end

      # @return [Fountain::Session::Unit]
      def current_unit
        Session.current_unit
      end
    end # BaseRepository
  end # Repository
end
