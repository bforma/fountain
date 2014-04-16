require 'spec_helper'

module Fountain::Command
  describe SerializationOptimizingInterceptor do
    it 'registers an optimizing listener to the current unit' do
      chain = double
      command = Object.new
      unit = double

      result = Object.new

      expect(unit).to receive(:register_listener)
      expect(chain).to receive(:proceed).with(command).and_return(result)

      expect(subject.call(chain, command, unit)).to be(result)
    end
  end

  describe SerializationOptimizingListener do
    it 'wraps events with serialization aware decorators' do
      unit = Object.new

      envelope = Fountain::Envelope.build
      expect(subject.on_event_registered(unit, envelope)).to be_a(Fountain::Serializer::SerializationAwareEnvelope)

      envelope = Fountain::Domain::EventEnvelope.build
      expect(subject.on_event_registered(unit, envelope)).to be_a(Fountain::Serializer::SerializationAwareEventEnvelope)
    end
  end
end
