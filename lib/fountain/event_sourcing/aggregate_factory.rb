require 'active_support/core_ext/string/inflections'

module Fountain
  module EventSourcing
    class AggregateFactory
      STREAM_ID_FORMAT = '%s:%s'

      # @return [Class]
      attr_reader :aggregate_type

      # @return [String]
      attr_reader :type_identifier

      # @param [Class] aggregate_type
      def initialize(aggregate_type)
        @aggregate_type = aggregate_type
        @type_identifier = aggregate_type.name.demodulize
      end

      # @return [AggregateRoot]
      def create
        @aggregate_type.allocate
      end

      # @return [String]
      def stream_id(aggregate_id)
        format(STREAM_ID_FORMAT, type_identifier, aggregate_id)
      end
    end # AggregateFactory
  end # EventSourcing
end
