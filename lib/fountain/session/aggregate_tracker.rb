module Fountain
  module Session
    class AggregateTracker
      include Enumerable
      include Loggable

      def initialize
        @aggregates = {}
      end

      # Clears all tracked aggregates
      # @return [void]
      def clear
        @aggregates.clear
      end

      # @yield [Fountain::Domain::AggregateRoot]
      # @return [Enumerator]
      def each(&block)
        @aggregates.each_key(&block)
      end

      # Returns true if no aggregates are being tracked
      # @return [Boolean]
      def empty?
        @aggregates.empty?
      end

      # @param [Fountain::Domain::AggregateRoot] aggregate
      # @return [Fountain::Domain::AggregateRoot]
      def find_similar(aggregate)
        id = aggregate.id
        type = aggregate.class

        @aggregates.each_key.find do |candidate|
          candidate.id == id && candidate.is_a?(type)
        end
      end

      # Tracks an aggregate that will be persisted later
      #
      # @param [Fountain::Domain::AggregateRoot] aggregate
      # @param [Proc] callback
      # @return [void]
      def track(aggregate, callback)
        @aggregates[aggregate] = callback
      end

      # Persists all tracked aggregates
      # @return [void]
      def save
        logger.debug 'Persisting changes to registered aggregates'

        @aggregates.each do |aggregate, callback|
          if logger.debug?
            logger.debug "Persisting changes to aggregate [#{aggregate.class.name}] [#{aggregate.id}]"
          end

          callback.call(aggregate)
        end

        logger.debug 'Aggregates successfully persisted'
        @aggregates.clear
      end
    end # AggregateTracker
  end # Session
end
