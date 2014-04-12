require 'spec_helper'
require 'serializer/fixtures'

module Fountain::Serializer
  describe SerializedObjectCache do

    subject { described_class.new(envelope) }

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

    describe '#serialize_headers' do
      it 'caches serialized headers' do
        serialized_a = subject.serialize_headers(serializer, String)
        serialized_b = subject.serialize_headers(serializer, String)

        expect(serialized_a).to be(serialized_b)
      end

      it 'converts cached serialized headers if required' do
        converter_factory.register(ByteArrayToStringConverter.new)
        converter_factory.register(StringToByteArrayConverter.new)

        serialized_a = subject.serialize_headers(serializer, Array)
        serialized_b = subject.serialize_headers(serializer, String)

        expect(serializer.deserialize(serialized_a)).to eql(serializer.deserialize(serialized_b))
      end
    end

    describe '#serialize_payload' do
      it 'caches serialized payload' do
        serialized_a = subject.serialize_payload(serializer, String)
        serialized_b = subject.serialize_payload(serializer, String)

        expect(serialized_a).to be(serialized_b)
      end

      it 'converts cached serialized payload if required' do
        converter_factory.register(ByteArrayToStringConverter.new)
        converter_factory.register(StringToByteArrayConverter.new)

        serialized_a = subject.serialize_payload(serializer, Array)
        serialized_b = subject.serialize_payload(serializer, String)

        expect(serializer.deserialize(serialized_a)).to eql(serializer.deserialize(serialized_b))
      end
    end

  end
end
