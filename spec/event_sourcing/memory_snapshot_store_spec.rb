require 'spec_helper'
require 'event_sourcing/fixtures'

module Fountain::EventSourcing
  describe MemorySnapshotStore do

    let(:type_identifier) { 'InventoryItem' }

    describe '#load' do
      it 'returns nil if no snapshot is available' do
        expect(subject.load(type_identifier, SecureRandom.uuid)).to be_nil
      end

      it 'returns an aggregate instance if snapshot is available' do
        id = SecureRandom.uuid

        item = InventoryItem.new(id)
        item.commit_events

        subject.store(type_identifier, item)

        loaded = subject.load(type_identifier, id)
        expect(loaded).to be_an(InventoryItem)
        expect(loaded.version).to eql(item.version)
      end
    end

    describe '#store' do
      it 'raises an error when aggregate has uncommitted events' do
        expect {
          subject.store(type_identifier, InventoryItem.new(SecureRandom.uuid))
        }.to raise_error(ArgumentError)
      end
    end

  end
end
