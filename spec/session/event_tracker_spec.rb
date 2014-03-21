require 'spec_helper'

module Fountain::Session
  describe EventTracker do
    describe '#publish' do
      it 'publishes all staged events' do
        event_bus = Object.new
        events = [build_envelope, build_envelope]

        events.each { |event| subject.stage(event, event_bus) }

        expect(event_bus).to receive(:publish).with(*events)

        subject.publish

        expect(subject).to be_empty
      end

      it 'publishes all staged events to their respective buses' do
        event_bus_a = double
        event_bus_b = double

        events_a = [build_envelope, build_envelope]
        events_b = [build_envelope, build_envelope]

        events_a.each { |event| subject.stage(event, event_bus_a) }
        events_b.each { |event| subject.stage(event, event_bus_b) }

        expect(event_bus_a).to receive(:publish).with(*events_a)
        expect(event_bus_b).to receive(:publish).with(*events_b)

        subject.publish

        expect(subject).to be_empty
      end

      it 'continuously publishes events' do
        event_bus = double
        event_a = build_envelope
        event_b = build_envelope

        subject.stage(event_a, event_bus)

        expect(event_bus).to receive(:publish).with(event_a).ordered do
          subject.stage(event_b, event_bus)
        end
        expect(event_bus).to receive(:publish).with(event_b).ordered

        subject.publish
      end

      it 'permits recursive publication' do
        event_bus = double
        event_a = build_envelope
        event_b = build_envelope

        subject.stage(event_a, event_bus)

        expect(event_bus).to receive(:publish).with(event_a).ordered do
          subject.stage(event_b, event_bus)
          subject.publish
        end
        expect(event_bus).to receive(:publish).with(event_b).ordered

        subject.publish
      end
    end

    describe '#clear' do
      it 'removes all events staged for publication' do
        subject.stage(build_envelope, Object.new)

        expect(subject).to_not be_empty
        subject.clear
        expect(subject).to be_empty
      end
    end

    it 'exposes staged events via Enumerable' do
      [Object.new, Object.new].each do |event_bus|
        2.times { subject.stage(build_envelope, event_bus) }
      end

      expect(subject.each.count).to eql(4)
    end

    def build_envelope
      Fountain::Envelope.build do |builder|
        builder.payload = Object.new
      end
    end
  end
end
