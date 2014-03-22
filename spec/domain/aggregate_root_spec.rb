require 'spec_helper'
require 'domain/fixtures'

module Fountain::Domain
  describe AggregateRoot do
    subject { InventoryItem.new(SecureRandom.uuid) }

    describe '#commit_events' do
      it 'clears the journal and updates the last sequence number' do
        expect(subject.uncommitted_event_count).to eql(1)
        subject.commit_events
        expect(subject.uncommitted_event_count).to eql(0)
      end
    end
  end
end
