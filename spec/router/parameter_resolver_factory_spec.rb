require 'spec_helper'

module Fountain::Router
  describe ParameterResolverFactory do

    describe '#resolvers_for' do
      it 'raises an error when encountering splat arguments' do
        handler = lambda { |*args| }
        expect {
          subject.resolvers_for(handler.parameters)
        }.to raise_error(ParameterResolutionError)
      end

      it 'raises an error when encountering unresolved required arguments' do
        handler = lambda { |event| }
        expect {
          subject.resolvers_for(handler.parameters)
        }.to raise_error(ParameterResolutionError)
      end

      it 'ignores optional unresolved arguments' do
        handler = proc { |event| }
        subject.resolvers_for(handler.parameters)
      end

      it 'provides an array of resolvers' do
        subject.register(PayloadParameterResolver.new)
        subject.register(TimestampParameterResolver.new)

        handler = proc { |event, timestamp| }

        types = [
          PayloadParameterResolver,
          TimestampParameterResolver
        ]

        resolver_types = subject.resolvers_for(handler.parameters).map { |resolver| resolver.class }
        expect(resolver_types).to eql(types)
      end
    end

  end
end
