module Fountain
  module Domain
    # Represents the root entity of an aggregate
    #
    # Entities are not thread safe. When storing entities, exclude the journal instance variable
    # from persistence. The journal should be treated as transient.
    #
    # The version field is for optimistic concurrency and will not necessarily match up with
    # the sequence numbers assigned to events.
    module AggregateRoot
      # @return [Object]
      attr_reader :id

      # @return [Integer]
      attr_reader :version

      # @return [Boolean]
      attr_reader :deleted

      alias_method :deleted?, :deleted

      # @yield [EventEnvelope]
      # @return [undefined]
      def add_event_callback(&block)
        journal.add_callback(&block)
      end

      # @return [undefined]
      def commit_events
        @last_event_sequence_number = journal.last_sequence_number
        journal.commit
      end

      # @return [Boolean]
      def dirty?
        journal.size > 0
      end

      # @return [Enumerable]
      def uncommitted_events
        journal.events
      end

      private

      # @param [Object] payload
      # @param [Hash] headers
      # @return [EventEnvelope]
      def register_event(payload, headers = {})
        journal.push(payload, headers)
      end

      # @return [undefined]
      def mark_deleted
        @deleted = true
      end

      # @param [Integer] last_sequence_number
      # @return [undefined]
      def initialize_sequence_number(last_sequence_number)
        journal.last_committed_sequence_number = last_sequence_number
        @last_event_sequence_number = last_sequence_number >= 0 ? last_sequence_number : nil
      end

      # @return [Integer]
      def last_committed_sequence_number
        journal.last_committed_sequence_number
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
