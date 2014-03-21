require 'spec_helper'

module Fountain::Event
  describe SimpleEventBus do
    it 'broadcasts events to all subscribed listeners' do
      listener_a = double
      listener_b = double

      subject.subscribe(listener_a)
      subject.subscribe(listener_b)

      events = [build_envelope, [build_envelope, build_envelope]]

      expect(listener_a).to receive(:call).exactly(3)
      expect(listener_b).to receive(:call).exactly(3)

      subject.publish(*events)
    end

    it 'stops broadcasts events to unsubscribed listeners' do
      listener_a = double
      listener_b = double

      expect(listener_a).to receive(:call)
      expect(listener_b).to receive(:call)

      subject.subscribe(listener_a)
      subject.subscribe(listener_b)
      subject.publish(build_envelope)

      expect(listener_a).to receive(:call)

      subject.unsubscribe(listener_b)
      subject.publish(build_envelope)
    end

    def build_envelope
      Fountain::Envelope.build
    end
  end
end
