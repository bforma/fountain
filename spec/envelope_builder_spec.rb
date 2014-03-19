require 'spec_helper'

module Fountain
  describe EnvelopeBuilder do
    UUID_PATTERN = /(\w{8}(-\w{4}){3}-\w{12}?)/

    it 'populates sensible defaults for new envelopes' do
      payload = Object.new

      envelope = described_class.build do |builder|
        builder.payload = payload
      end

      expect(envelope.id).to match(UUID_PATTERN)
      expect(envelope.headers).to be_a(Hash)
      expect(envelope.payload).to be(payload)
      expect(envelope.timestamp).to be_a(Time)
    end
  end
end
