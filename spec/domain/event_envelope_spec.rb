require 'spec_helper'

module Fountain::Domain
  describe EventEnvelope do
    subject {
      described_class.build { |builder|
        builder.sequence_number = sequence_number
      }
    }

    let(:sequence_number) { 123 }

    it 'populates duplicates with the sequence number' do
      x = { foo: 1 }
      y = { bar: 2 }

      mx = subject.and_headers(x)
      expect(mx.sequence_number).to eql(sequence_number)

      my = mx.and_headers(y)
      expect(my.sequence_number).to eql(sequence_number)
    end
  end
end
