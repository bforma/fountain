require 'spec_helper'
require 'domain/fixtures'

module Fountain::Domain
  describe AggregateRoot do
    subject { InventoryItem.new(SecureRandom.uuid) }

    describe '#commit_events' do
      it 'clears the journal and updates the last sequence number' do
        expect(subject).to be_dirty
        subject.commit_events
        expect(subject).to_not be_dirty
      end
    end

    it 'maintains sequence after being marshalled' do
      events = []
      callback = lambda do |event|
        events << event
        event
      end

      subject.add_event_callback(&callback)
      subject.commit_events

      blob = Marshal.dump(subject)
      loaded = Marshal.load(blob)

      loaded.add_event_callback(&callback)
      loaded.check_in(100)

      expect(events.size).to eql(2)
      expect(events[0].sequence_number).to eql(0)
      expect(events[1].sequence_number).to eql(1)
    end
  end
end
