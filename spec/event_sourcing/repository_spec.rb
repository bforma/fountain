require 'spec_helper'
require 'event_sourcing/fixtures'

module Fountain::EventSourcing
  describe Repository do

    subject { described_class.build(InventoryItem, event_store) }
    let(:event_bus) { Fountain::Event::SimpleEventBus.new }
    let(:event_store) { Fountain::EventStore::MemoryEventStore.new }

    before do
      subject.event_bus = event_bus
    end

    describe '#load' do
      it 'loads an aggregate from an event store' do
        item = InventoryItem.new(123)
        item.check_in(100)

        with_unit do
          subject.add(item)
        end

        with_unit do
          item = subject.load(123)
          expect(item.quantity).to eql(100)
        end
      end

      it 'raises an error if event stream not found' do
        expect {
          subject.load(123)
        }.to raise_error(Fountain::Repository::AggregateNotFoundError)
      end

      it 'raises an error when loading a deleted aggregate' do
        item = InventoryItem.new(123)
        item.delete

        with_unit do
          subject.add(item)
        end

        expect {
          subject.load(123)
        }.to raise_error(AggregateDeletedError)
      end
    end

    def with_unit
      unit = Fountain::Session::Unit.start
      yield
      unit.commit
    end

  end
end
