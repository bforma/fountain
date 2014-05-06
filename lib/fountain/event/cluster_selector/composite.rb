module Fountain
  module Event
    # Implementation of a cluster selector that delegates selection to a list of selectors,
    # trying each one until a cluster is selected.
    class CompositeClusterSelector
      # @param [Enumerable] selectors
      def initialize(selectors)
        @selectors = selectors
      end

      # @param [Object] listener
      # @return [Cluster]
      def call(listener)
        cluster = nil
        @selectors.find do |selector|
          cluster = selector.call(listener)
        end

        cluster
      end
    end # CompositeClusterSelector
  end # Event
end
