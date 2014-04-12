module Fountain
  module Router
    class EnvelopeHandler
      include Comparable

      # @return [EnvelopeHandlerScore]
      attr_reader :score

      # @param [Class] payload_type
      # @param [Object] handler
      # @param [Hash] options
      def initialize(payload_type, handler, options = {})
        @payload_type = payload_type
        @handler = handler
        @options = options

        @score = EnvelopeHandlerScore.new(payload_type)
      end

      # @param [Envelope] envelope
      # @return [Boolean]
      def match?(envelope)
        @payload_type >= envelope.payload_type
      end

      # @param [Object] target
      # @param [Envelope] envelope
      # @return [Object] Result of the invocation
      def invoke(target, envelope)
        if @handler.is_a?(Symbol)
          method = target.method(@handler)
          parameters = resolve(method.parameters, envelope)
          method.call(*parameters)
        else
          parameters = resolve(@handler.parameters, envelope)
          target.instance_exec(*parameters, &@handler)
        end
      end

      # @param [EnvelopeHandler] other
      # @return [Integer]
      def <=>(other)
        @score <=> other.score
      end

      # @param [EnvelopeHandler] other
      # @return [Boolean]
      def ==(other)
        other.is_a?(self.class) && other.score == @score
      end

      alias_method :eql?, :==

      # @return [Integer]
      def hash
        @score.hash
      end

      # @return [Boolean]
      def auto_resolve?
        @options.fetch(:auto_resolve, true)
      end

      private

      # @param [Array] parameters
      # @param [Envelope] envelope
      # @return [Array]
      def resolve(parameters, envelope)
        if auto_resolve?
          @resolvers ||= Router.resolver_factory.resolvers_for(parameters)
          @resolvers.map do |resolver|
            resolver.resolve(envelope) if resolver
          end
        else
          limit = parameters.size - 1
          [envelope.payload, envelope][0..limit]
        end
      end
    end # EnvelopeHandler
  end # Router
end
