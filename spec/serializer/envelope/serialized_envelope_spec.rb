require 'spec_helper'
require 'serializer/fixtures'

module Fountain::Serializer
  describe SerializedEnvelope do

    subject do
      headers = serializer.serialize({}, String)
      payload = serializer.serialize(payload, String)

      described_class.build do |builder|
        builder.id = SecureRandom.uuid
        builder.from_serialized(headers, payload, serializer)
        builder.timestamp = Time.now
      end
    end

    let(:serializer) { MarshalSerializer.new(converter_factory) }
    let(:converter_factory) { ConverterFactory.new }

    let(:payload) { ItemsCheckedIn.new(SecureRandom.uuid, 100) }

    it_should_behave_like 'an envelope'
  end
end
