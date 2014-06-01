module Fountain
  module Domain
    # Represents the root entity of an aggregate
    #
    # The +id+ and +version+ fields must be implemented by entities.
    #
    # Entities are not thread safe. When storing entities, exclude the journal instance variable
    # from persistence. The journal should be treated as transient.
    module AggregateRoot
      include Serialization

      # @return [Boolean]
      attr_reader :deleted

      alias_method :deleted?, :deleted

      # @yield [EventEnvelope]
      # @return [void]
      def add_event_callback(&block)
        journal.add_callback(&block)
      end

      # @return [void]
      def commit_events
        @last_event_sequence_number = journal.last_sequence_number
        journal.commit
      end

      # @return [Enumerable]
      def uncommitted_events
        journal.events
      end

      # @return [Integer]
      def uncommitted_event_count
        journal.size
      end

      # @return [Enumerable]
      def excluded_properties
        [:@journal]
      end

      private

      # @return [void]
      def mark_deleted
        @deleted = true
      end

      # @param [Object] payload
      # @param [Hash] headers
      # @return [EventEnvelope]
      def register_event(payload, headers = {})
        journal.push(payload, headers)
      end

      # @param [Integer] last_sequence_number
      # @return [void]
      def initialize_sequence_number(last_sequence_number)
        journal.last_committed_sequence_number = last_sequence_number
        @last_event_sequence_number = last_sequence_number >= 0 ? last_sequence_number : nil
      end

      # @return [Journal]
      def journal
        unless @journal
          @journal = Journal.new
          @journal.last_committed_sequence_number = @last_event_sequence_number
        end

        @journal
      end
    end # AggregateRoot
  end # Domain
end
