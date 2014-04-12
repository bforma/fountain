shared_examples 'an envelope' do
  EMPTY_HASH = {}.freeze

  describe '#headers' do
    it 'acts like Hash' do
      expect(subject.headers).to be_a(Hash)
    end
  end

  describe '#timestamp' do
    it 'acts like Time' do
      expect(subject.timestamp).to be_a(Time)
    end
  end

  describe '#and_headers' do
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

  describe '#with_headers' do
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
