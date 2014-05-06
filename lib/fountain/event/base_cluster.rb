module Fountain
  module Event
    class BaseCluster < Cluster
      # @return [String]
      attr_reader :name

      # @return [ClusterMetadata]
      attr_reader :metadata

      # @param [String] name
      def initialize(name)
        @name = name
        @members = ConcurrentSet.new
        @metadata = ClusterMetadata.new
      end

      # @param [Envelope...] events
      # @return [void]
      def publish(*events)
        events.each do |event|
          @members.each do |listener|
            listener.call(event)
          end
        end
      end

      # @param [Object] listener
      # @return [void]
      def subscribe(listener)
        @members.add(listener)
      end

      # @param [Object] listener
      # @return [void]
      def unsubscribe(listener)
        @members.delete(listener)
      end

      # @return [Enumerable]
      def members
        @members.to_a
      end
    end # BaseCluster
  end # Event
end
