require 'spec_helper'

describe Fountain::Envelope do
  EMPTY_HASH = {}.freeze

  subject {
    described_class.build { |builder|
      builder.payload = payload
    }
  }

  let(:payload) { Object.new }

  describe '#as_message' do
    it 'returns the given object already an envelope' do
      expect(described_class.as_message(subject)).to be(subject)
    end

    it 'wraps the given object as the payload in an envelope' do
      envelope = described_class.as_message(payload)
      expect(envelope.payload).to be(payload)
    end
  end

  describe '#and_metadata' do
    it 'returns a duplicate envelope with merged headers' do
      x = { foo: 0, bar: 1 }
      y = { foo: 2, baz: 3 }

      mx = subject.and_headers(x)
      expect(mx.headers).to eql(x)

      my = mx.and_headers(y)
      expect(my.headers).to eql(x.merge(y))
    end

    it 'returns itself when no additional headers are given' do
      m = subject.and_headers(EMPTY_HASH)
      expect(m).to be(subject)
    end
  end

  describe '#with_metadata' do
    it 'returns a duplicate envelope with replaced headers' do
      x = { foo: 0, bar: 1 }
      y = { foo: 2, baz: 3 }

      mx = subject.with_headers(x)
      expect(mx.headers).to be(x)

      my = mx.with_headers(y)
      expect(my.headers).to be(y)
    end

    it 'returns itself when the replacement headers are the same' do
      x = { foo: 0 }

      mx = subject.with_headers(x)
      my = mx.with_headers(x)

      expect(mx).to be(my)
    end
  end

  describe '#payload_type' do
    it 'returns the class of the payload' do
      expect(subject.payload_type).to be(subject.payload.class)
    end
  end
end
