module Fountain
  module EventStore
    # Represents a mechanism for reading and manipulating event streams
    # @abstract
    class EventStore
      # @abstract
      # @param [String] stream_id
      # @param [Integer] first
      # @param [Integer] last
      # @return [Enumerable]
      def load_slice(stream_id, first, last = -1)
        raise NotImplementedError
      end

      # @abstract
      # @param [String] stream_id
      # @return [Enumerable]
      def load_all(stream_id)
        raise NotImplementedError
      end

      # @abstract
      # @param [String] stream_id
      # @param [Enumerable] events
      def append(stream_id, events)
        raise NotImplementedError
      end
    end # EventStore
  end # EventStore
end
