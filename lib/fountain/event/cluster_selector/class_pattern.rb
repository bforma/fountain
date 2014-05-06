module Fountain
  module Event
    class ClassPatternClusterSelector
      include ListenerProxyAware

      # @param [Cluster] cluster
      # @param [Object] pattern
      def initialize(cluster, pattern)
        @cluster = cluster
        @pattern = Regexp.new(pattern)
      end

      # @param [Object] listener
      # @return [Cluster]
      def call(listener)
        @cluster if @pattern.match(resolve_listener_type(listener).name)
      end
    end # ClassPatternClusterSelector
  end # Event
end
