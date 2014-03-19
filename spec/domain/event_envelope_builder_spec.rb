require 'spec_helper'

module Fountain::Domain
  describe EventEnvelopeBuilder do
    it 'builds EventEnvelope instances' do
      subject.sequence_number = 123
      envelope = subject.build
      expect(envelope.sequence_number).to eql(subject.sequence_number)
    end
  end
end
