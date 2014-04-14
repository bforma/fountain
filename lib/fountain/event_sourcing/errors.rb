module Fountain
  module EventSourcing
    class AggregateDeletedError < NonTransientError
      # @return [Class]
      attr_reader :aggregate_type

      # @return [Object]
      attr_reader :aggregate_id

      # @param [Class] aggregate_type
      # @param [Object] aggregate_id
      def initialize(aggregate_type, aggregate_id)
        super(format('Aggregate [%s] [%s] found, but marked for deletion', aggregate_type, aggregate_id))

        @aggregate_type = aggregate_type
        @aggregate_id = aggregate_type
      end
    end
  end
end
