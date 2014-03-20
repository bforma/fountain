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
  end
end
