require 'spec_helper'

module Fountain::Domain
  describe Journal do

    EMPTY_HASH = {}.freeze
    EMPTY_LAMBDA = lambda {}

    let(:event) { Object.new }

    describe '#push' do
      it 'appends the event to the end of the journal' do
        expect(subject.size).to eql(0)
        envelope = subject.push(event, EMPTY_HASH)
        expect(subject.size).to eql(1)
        expect(subject.events.last).to be(envelope)

        expect(envelope.payload).to be(event)
        expect(envelope.sequence_number).to eql(subject.last_sequence_number)
      end

      it 'processes envelopes using callbacks before appending them' do
        headers = { foo: 0 }

        subject.add_callback do |envelope|
          envelope.with_headers(headers)
        end

        envelope = subject.push(event, EMPTY_HASH)
        expect(envelope.headers).to eql(headers)
      end
    end

    describe '#add_callback' do
      it 'processes envelopes already in the journal' do
        subject.push(Object.new, EMPTY_HASH)
        subject.push(Object.new, EMPTY_HASH)

        headers = { foo: 0 }

        subject.add_callback do |envelope|
          envelope.with_headers(headers)
        end

        subject.events.each do |envelope|
          expect(envelope.headers).to eql(headers)
        end
      end
    end

    describe '#commit' do
      it 'clears events and updates the last committed sequence number' do
        subject.push(event, EMPTY_HASH)
        subject.push(event, EMPTY_HASH)
        expect(subject.size).to eql(2)
        expect(subject.last_sequence_number).to eql(1)

        subject.commit
        expect(subject.size).to eql(0)
        expect(subject.last_committed_sequence_number).to eql(1)
      end
    end

  end
end
