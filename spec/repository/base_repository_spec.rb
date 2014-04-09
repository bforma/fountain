require 'spec_helper'

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
          subject.add(BadAggregate.new)
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

  class StubAggregate
    include Fountain::Domain::AggregateRoot
    attr_reader :id, :version
  end

  class BadAggregate
    include Fountain::Domain::AggregateRoot
    attr_reader :id, :version
  end
end
