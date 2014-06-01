module Fountain
  module EventStore
    # Thread-safe, in-memory event store
    class MemoryEventStore < EventStore
      STREAM_KEY_FORMAT = '%s:%s'

      def initialize
        @streams = ThreadSafe::Cache.new
      end

      # Clears all streams from this event store
      #
      # Note that this method is volatile and should not be called while callers are
      # interacting with this event store
      #
      # @return [void]
      def clear
        @streams.clear
      end

      # @param [String] stream_type
      # @param [Object] stream_id
      # @param [Integer] first
      # @param [Integer] last
      # @return [Enumerable]
      def load_slice(stream_type, stream_id, first, last = -1)
        key = stream_key_for(stream_type, stream_id)

        unless @streams.key?(key)
          raise StreamNotFoundError
        end

        @streams[key].slice(first, last)
      end

      # @param [String] stream_type
      # @param [Object] stream_id
      # @return [Enumerable]
      def load_all(stream_type, stream_id)
        load_slice(stream_type, stream_id, 0)
      end

      # @param [String] stream_type
      # @param [Object] stream_id
      # @param [Enumerable] events
      def append(stream_type, stream_id, events)
        return if events.first.nil?

        key = stream_key_for(stream_type, stream_id)
        stream = @streams.compute_if_absent(key) do
          MemoryStream.new
        end

        stream.append(events)
      end

      private

      # @param [String] stream_type
      # @param [Object] stream_id
      # @return [String]
      def stream_key_for(stream_type, stream_id)
        format(STREAM_KEY_FORMAT, stream_type, stream_id)
      end
    end # MemoryEventStore
  end # EventStore
end
