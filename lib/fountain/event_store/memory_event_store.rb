module Fountain
  module EventStore
    # Thread-safe, in-memory event store
    class MemoryEventStore
      def initialize
        @mutex = Mutex.new
        @streams = {}
      end

      # @param [String] stream_id
      # @param [Integer] version
      # @return [Enumerable]
      def load_since(stream_id, version)
        @mutex.synchronize do
          unless @streams.key?(stream_id)
            raise StreamNotFoundError
          end

          @streams[stream_id][version..-1]
        end
      end

      # @param [String] stream_id
      # @return [Enumerable]
      def load_all(stream_id)
        @mutex.synchronize do
          unless @streams.key?(stream_id)
            raise StreamNotFoundError
          end

          @streams[stream_id].dup
        end
      end

      # @param [String] stream_id
      # @param [Enumerable] events
      def append(stream_id, events)
        @mutex.synchronize do
          stream = @streams[stream_id] ||= []

          if stream[events.first.sequence_number]
            raise Repository::ConcurrencyError
          end

          events.each do |event|
            stream.push(event)
          end
        end
      end
    end # MemoryEventStore
  end # EventStore
end
