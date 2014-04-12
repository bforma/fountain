require 'spec_helper'

module Fountain::EventStore
  describe MemoryEventStore do

    let(:stream_id) { SecureRandom.uuid }

    describe '#load_since' do
      it 'raises an error on non-existent stream' do
        expect {
          subject.load_since(stream_id, 10)
        }.to raise_error(StreamNotFoundError)
      end

      it 'returns a partial stream starting at the given version' do
        subject.append(stream_id, build_stream(10))
        expect(subject.load_since(stream_id, 5).size).to eql(5)
      end
    end

    describe '#load_since' do
      it 'raises an error on non-existent stream' do
        expect {
          subject.load_since(stream_id, 10)
        }.to raise_error(StreamNotFoundError)
      end

      it 'returns a partial stream starting at the given version' do
        subject.append(stream_id, build_stream(10))
        expect(subject.load_all(stream_id).size).to eql(10)
      end
    end

    describe '#append' do
      it 'raises an error on duplicate sequence numbers' do
        subject.append(stream_id, build_stream(2))
        subject.append(stream_id, build_stream(2, 2))
        expect {
          subject.append(stream_id, build_stream(2, 2))
        }.to raise_error
      end
    end

    def build_stream(size, offset = 0)
      size.times.map do |sequence_number|
        Fountain::Domain::EventEnvelope.build do |builder|
          builder.payload = Object.new
          builder.sequence_number = sequence_number + offset
        end
      end
    end

  end
end
