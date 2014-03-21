module Fountain
  module Domain
    class Journal
      # @return [Integer]
      attr_accessor :last_committed_sequence_number

      # @return [void]
      def initialize
        @callbacks = []
        @events = []
      end

      # @param [Object] payload
      # @param [Hash] headers
      # @return [EventEnvelope]
      def push(payload, headers)
        event = EventEnvelope.build do |builder|
          builder.headers = headers
          builder.payload = payload
          builder.sequence_number = next_sequence_number
        end

        @callbacks.each do |callback|
          event = callback.call(event)
        end

        @last_sequence_number = event.sequence_number
        @events.push(event)

        event
      end

      # @yield [EventEnvelope]
      # @return [void]
      def add_callback(&block)
        @callbacks.push(block)

        @events.map! do |event|
          block.call(event)
        end
      end

      # @return [void]
      def commit
        @last_committed_sequence_number = last_sequence_number
        @events.clear
        @callbacks.clear
      end

      # @return [Enumerable]
      def events
        @events.dup
      end

      # @return [Integer]
      def size
        @events.size
      end

      # @return [Integer]
      def last_sequence_number
        if @events.empty?
          @last_committed_sequence_number
        else
          @last_sequence_number
        end
      end

      private

      # @return [Integer]
      def next_sequence_number
        current = last_sequence_number
        current ? current.next : 0
      end
    end # Journal
  end # Domain
end
