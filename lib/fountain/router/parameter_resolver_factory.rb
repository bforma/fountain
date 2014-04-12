module Fountain
  module Router
    class ParameterResolverFactory
      def initialize
        @resolvers = ConcurrentList.new
      end

      # @return [void]
      def clear
        @resolvers.clear
      end

      # @param [ParameterResolver] resolver
      # @return [void]
      def register(resolver)
        @resolvers.push(resolver)
      end

      # @param [Array] parameters
      # @return [Array]
      def resolvers_for(parameters)
        parameters.each_with_index.map do |spec, index|
          type, name = *spec

          if :rest == type
            raise ParameterResolutionError, "Method signature contains splat argument #{name}"
          end

          resolver = find_resolver(index, name)

          if :req == type && resolver.nil?
            raise ParameterResolutionError, "No resolver found for required argument #{name}"
          end

          resolver
        end
      end

      private

      # @param [Integer] index
      # @param [Symbol] name
      # @return [ParameterResolver] Returns nil if no resolver found
      def find_resolver(index, name)
        @resolvers.find do |resolver|
          resolver.can_resolve?(index, name)
        end
      end
    end # ParameterResolverFactory
  end # Router
end
