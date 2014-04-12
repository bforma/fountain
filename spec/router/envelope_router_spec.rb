require 'spec_helper'

module Fountain::Router
  describe EnvelopeRouter do

    let(:target) { Object.new }
    let(:envelope) do
      Fountain::Envelope.build do |builder|
        builder.payload = TestPayload.new
      end
    end

    before do
      stub_const('TestPayload', Class.new)
    end

    describe '#route_first' do
      it 'routes an envelope to the first matching handler' do
        result = Object.new

        subject.add_route(TestPayload) do |event|
          result
        end

        expect(subject.route_first(target, envelope)).to be(result)
      end
    end

    describe '#route_first!' do
      it 'raises an error if no matching handler found' do
        expect {
          subject.route_first!(target, envelope)
        }.to raise_error(NoHandlerError)
      end
    end

  end
end
