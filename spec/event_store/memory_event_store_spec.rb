require 'spec_helper'

module Fountain::EventStore
  describe MemoryEventStore do

    let(:stream_id) { SecureRandom.uuid }

    describe '#load_slice' do
      it 'raises an error on non-existent stream' do
        expect {
          subject.load_slice(stream_id, 10)
        }.to raise_error(StreamNotFoundError)
      end

      it 'returns a partial stream starting at the given version' do
        subject.append(stream_id, build_stream(10))
        expect(subject.load_slice(stream_id, 5).size).to eql(5)
      end

      it 'returns a partial stream starting and ending at the given versions' do
        subject.append(stream_id, build_stream(10))

        expect(subject.load_slice(stream_id, 5, 6).size).to eql(2)
        expect(subject.load_slice(stream_id, 5, 100).size).to eql(5)
      end
    end

    describe '#load_all' do
      it 'raises an error on non-existent stream' do
        expect {
          subject.load_all(stream_id)
        }.to raise_error(StreamNotFoundError)
      end

      it 'returns the entire event stream' do
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
