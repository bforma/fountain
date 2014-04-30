module Fountain
  module EventStore
    # Represents a mechanism for reading and manipulating event streams
    class EventStore
      include AbstractType

      # @param [String] stream_id
      # @param [Integer] first
      # @param [Integer] last
      # @return [Enumerable]
      abstract_method :load_slice

      # @param [String] stream_id
      # @return [Enumerable]
      abstract_method :load_all

      # @param [String] stream_id
      # @param [Enumerable] events
      abstract_method :append
    end # EventStore
  end # EventStore
end
