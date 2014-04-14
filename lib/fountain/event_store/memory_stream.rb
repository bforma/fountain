module Fountain
  module EventStore
    class MemoryStream
      def initialize
        @mutex = Mutex.new
        @events = []
      end

      # @param [Enumerable] events
      # @return [void]
      def append(events)
        @mutex.synchronize do
          unless @events.size == events.first.sequence_number
            raise Repository::ConcurrencyError
          end

          events.each do |event|
            @events.push(event)
          end
        end
      end

      # @param [Integer] first
      # @param [Integer] last
      # @return [Enumerable]
      def slice(first, last)
        @mutex.synchronize do
          @events[first..last]
        end
      end
    end # MemoryStream
  end # EventStore
end
