module Fountain
  module Repository
    class AggregateNotFoundError < NonTransientError
      # @return [Class]
      attr_reader :aggregate_type

      # @return [Object]
      attr_reader :aggregate_id

      # @param [Class] aggregate_type
      # @param [Object] aggregate_id
      def initialize(aggregate_type, aggregate_id)
        super(format('Aggregate [%s] [%s] not found', aggregate_type, aggregate_id))

        @aggregate_type = aggregate_type
        @aggregate_id = aggregate_type
      end
    end

    class ConcurrencyError < TransientError
    end

    class ConflictingModificationError < NonTransientError
    end

    class ConflictingAggregateVersionError < ConflictingModificationError
      # @return [Object]
      attr_reader :aggregate_id

      # @return [Integer]
      attr_reader :expected_version, :actual_version

      # @param [Object] aggregate_id
      # @param [Integer] expected_version
      # @param [Integer] actual_version
      def initialize(aggregate_id, expected_version, actual_version)
        super(format('Aggregate [%s] version [%s] was expected to be [%s]',
                     aggregate_id, actual_version, expected_version))

        @aggregate_id = aggregate_id
        @expected_version = expected_version
        @actual_version = actual_version
      end
    end
  end
end
