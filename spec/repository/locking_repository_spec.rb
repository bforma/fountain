require 'spec_helper'
require 'repository/fixtures'

module Fountain::Repository
  describe LockingRepository do
    subject {
      StubLockingRepository.new(StubAggregate, lock_manager)
    }

    let(:lock_manager) { Object.new }

    before(:each) { Fountain::Session::Unit.start }
    after(:each) { Fountain::Session::UnitStack.rollback_all }

    describe '#add' do
      it 'obtains a lock when adding an aggregate' do
        aggregate = StubAggregate.new

        expect(lock_manager).to receive(:obtain_lock).with(aggregate.id).ordered
        subject.add(aggregate)

        expect(lock_manager).to receive(:validate_lock).with(aggregate).and_return(true).ordered
        expect(lock_manager).to receive(:release_lock).with(aggregate.id).ordered
        Fountain::Session::UnitStack.commit
      end

      it 'releases a lock if adding an aggregate fails' do
        aggregate = SomeOtherAggregate.new

        expect(lock_manager).to receive(:obtain_lock).with(aggregate.id).ordered
        expect(lock_manager).to receive(:release_lock).with(aggregate.id).ordered

        expect {
          subject.add(aggregate)
        }.to raise_error(ArgumentError)
      end
    end

    describe '#load' do
      it 'obtains a lock when loading an aggregate' do
        aggregate = StubAggregate.new
        subject.aggregate = aggregate

        expect(lock_manager).to receive(:obtain_lock).with(aggregate.id).ordered
        expect(subject.load(aggregate.id)).to be(aggregate)

        expect(lock_manager).to receive(:validate_lock).with(aggregate).and_return(true).ordered
        expect(lock_manager).to receive(:release_lock).with(aggregate.id).ordered
        Fountain::Session::UnitStack.commit
      end

      it 'releases a lock if loading an aggregate fails' do
        aggregate_id = SecureRandom.uuid

        expect(lock_manager).to receive(:obtain_lock).with(aggregate_id).ordered
        expect(lock_manager).to receive(:release_lock).with(aggregate_id).ordered

        expect {
          subject.load(aggregate_id)
        }.to raise_error(AggregateNotFoundError)
      end
    end
  end

  class StubLockingRepository < LockingRepository
    attr_accessor :aggregate

    private

    def perform_load(aggregate_id, expected_version)
      raise AggregateNotFoundError unless @aggregate
      @aggregate
    end

    def perform_save(aggregate)
    end

    def perform_delete(aggregate)
    end
  end
end
