require 'fountain/router/envelope_handler'
require 'fountain/router/envelope_handler_score'
require 'fountain/router/envelope_router'
require 'fountain/router/errors'
require 'fountain/router/parameter_resolver'
require 'fountain/router/parameter_resolver_factory'

module Fountain
  module Router
    extend self

    DEFAULT_RESOLVER_TYPES = [
      PayloadParameterResolver,
      EnvelopeParameterResolver,
      HeadersParameterResolver,
      TimestampParameterResolver,
      SequenceNumberParameterResolver,
    ]

    # @return [ParameterResolverFactory]
    attr_accessor :resolver_factory

    # @return [EnvelopeRouter]
    def create_router
      EnvelopeRouter.new
    end

    # @return [void]
    def setup_resolver_factory
      @resolver_factory = ParameterResolverFactory.new

      DEFAULT_RESOLVER_TYPES.each do |resolver_type|
        @resolver_factory.register(resolver_type.new)
      end
    end

    setup_resolver_factory
  end
end
