require 'spec_helper'

describe Fountain::Envelope do
  subject {
    described_class.build { |builder|
      builder.payload = payload
    }
  }

  let(:payload) { Object.new }

  describe '#as_envelope' do
    it 'returns the given object already an envelope' do
      expect(described_class.as_envelope(subject)).to be(subject)
    end

    it 'wraps the given object as the payload in an envelope' do
      envelope = described_class.as_envelope(payload)
      expect(envelope.payload).to be(payload)
    end
  end

  it_should_behave_like 'an envelope'
end
