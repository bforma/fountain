require 'spec_helper'
require 'repository/fixtures'

module Fountain::Repository
  describe BaseRepository do
    subject { StubRepository.new(StubAggregate) }

    before(:each) do
      Fountain::Session::Unit.start
    end

    after(:each) do
      Fountain::Session::UnitStack.rollback_all
    end

    describe '#add' do
      it 'accepts aggregates with the correct type' do
        subject.add(StubAggregate.new)
      end

      it 'rejects aggregates without the correct type' do
        expect {
          subject.add(SomeOtherAggregate.new)
        }.to raise_error(ArgumentError)
      end

      it 'rejects existing aggregates' do
        expect {
          subject.add(StubAggregate.new(SecureRandom.uuid, 1))
        }.to raise_error(ArgumentError)
      end
    end
  end

  class StubRepository < BaseRepository
    private

    def perform_load(aggregate_id, expected_version)
    end

    def perform_save(aggregate)
    end

    def perform_delete(aggregate)
    end
  end
end
