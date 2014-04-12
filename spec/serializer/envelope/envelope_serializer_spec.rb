require 'spec_helper'
require 'serializer/fixtures'

module Fountain::Serializer
  describe EnvelopeSerializer do

    subject { described_class.new(serializer) }

    let(:converter_factory) { ConverterFactory.new }
    let(:serializer) { MarshalSerializer.new(converter_factory) }

    let(:envelope) do
      Fountain::Envelope.build do |builder|
        builder.headers = {
          user_id: SecureRandom.uuid
        }
        builder.payload = ItemsCheckedIn.new(SecureRandom.uuid, 100)
      end
    end

    let(:aware_envelope) { SerializationAwareEnvelope.new(envelope) }

    describe '#serialize_headers' do
      it 'delegates serialization to envelope if serialization aware' do
        serialized = subject.serialize_headers(aware_envelope, String)
        expect(subject.deserialize(serialized)).to eql(envelope.headers)
      end

      it 'delegates serialization to serializer if envelope not serialization aware' do
        serialized = subject.serialize_headers(envelope, String)
        expect(subject.deserialize(serialized)).to eql(envelope.headers)
      end
    end

    describe '#serialize_payload' do
      it 'delegates serialization to envelope if serialization aware' do
        serialized = subject.serialize_payload(aware_envelope, String)
        expect(subject.deserialize(serialized)).to eql(envelope.payload)
      end

      it 'delegates serialization to serializer if envelope not serialization aware' do
        serialized = subject.serialize_payload(envelope, String)
        expect(subject.deserialize(serialized)).to eql(envelope.payload)
      end
    end

  end
end
