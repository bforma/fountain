require 'spec_helper'

module Fountain::Session
  describe UnitStack do
    let(:unit) { Unit.new }

    after(:each) do
      expect(subject).to_not be_active
    end

    describe '#current' do
      it 'raises an error when stack is empty' do
        expect {
          subject.current
        }.to raise_error(Fountain::InvalidStateError)
      end

      it 'returns the active unit of work' do
        unit.start
        expect(subject.current).to be(unit)

        subject.clear(unit)
      end
    end

    it 'commits the active unit of work' do
      unit.start
      expect(unit).to be_started

      subject.commit
      expect(unit).to_not be_started
    end

    it 'rolls back the active unit of work' do
      unit.start
      expect(unit).to be_started

      subject.rollback
      expect(unit).to_not be_started
    end

    it 'raises an error when stack is cleared out of order' do
      unit.start

      expect {
        subject.clear(Unit.new)
      }.to raise_error(ArgumentError)

      subject.clear(unit)
    end
  end
end
