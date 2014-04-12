require 'spec_helper'
require 'event_sourcing/fixtures'

module Fountain::EventSourcing
  describe AggregateRoot do

    subject { InventoryItem.new(id) }
    let(:id) { SecureRandom.uuid }

    describe '#initialize_from_stream' do
      it 'initializes the aggregate state from an event stream' do
        subject.check_in(100)

        stream = subject.uncommitted_events
        expect(stream.size).to eql(2)
        subject = InventoryItem.new_from_stream(stream)

        expect(subject.id).to eql(id)
        expect(subject.quantity).to eql(100)
      end
    end

  end
end
