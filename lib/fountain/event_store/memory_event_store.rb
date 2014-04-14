module Fountain
  module EventStore
    # Thread-safe, in-memory event store
    class MemoryEventStore < EventStore
      def initialize
        @streams = ThreadSafe::Cache.new
      end

      # @param [String] stream_id
      # @param [Integer] first
      # @param [Integer] last
      # @return [Enumerable]
      def load_slice(stream_id, first, last = -1)
        unless @streams.key?(stream_id)
          raise StreamNotFoundError
        end

        @streams[stream_id].slice(first, last)
      end

      # @param [String] stream_id
      # @return [Enumerable]
      def load_all(stream_id)
        load_slice(stream_id, 0)
      end

      # @param [String] stream_id
      # @param [Enumerable] events
      def append(stream_id, events)
        stream = @streams.compute_if_absent(stream_id) do
          MemoryStream.new
        end

        stream.append(events)
      end
    end # MemoryEventStore
  end # EventStore
end
