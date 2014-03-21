require 'spec_helper'

module Fountain::Session
  describe AggregateTracker do
    describe '#save' do
      it 'persists tracked aggregates using their respective callbacks' do
        aggregate = double(id: 123)
        callback = double

        subject.track(aggregate, callback)

        expect(callback).to receive(:call).with(aggregate)

        subject.save

        expect(subject).to be_empty
      end
    end

    describe '#find_similar' do
      it 'returns a tracked aggregate matching the given aggregate' do
        stub_const('TestA', Struct.new(:id))
        stub_const('TestB', Struct.new(:id))

        aggregate_a = TestA.new(1)
        aggregate_b = TestA.new(1)
        aggregate_c = TestA.new(2)
        aggregate_d = TestB.new(1)

        callback = double

        subject.track(aggregate_a, callback)
        expect(subject.find_similar(aggregate_b)).to be(aggregate_a)
        expect(subject.find_similar(aggregate_c)).to be_nil
        expect(subject.find_similar(aggregate_d)).to be_nil
      end
    end

    describe '#clear' do
      it 'removes all tracked aggregates' do
        subject.track(double(id: 123), double)

        expect(subject).to_not be_empty
        subject.clear
        expect(subject).to be_empty
      end
    end

    it 'exposes aggregates via Enumerable' do
      aggregates = [
        double(id: 1),
        double(id: 2)
      ]
      callback = double

      aggregates.each do |aggregate|
        subject.track(aggregate, callback)
      end

      expect(subject.each.count).to eql(aggregates.size)
    end
  end
end
