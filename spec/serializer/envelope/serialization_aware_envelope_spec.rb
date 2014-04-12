require 'spec_helper'
require 'serializer/fixtures'

module Fountain::Serializer
  describe SerializationAwareEnvelope do

    subject { described_class.decorate(envelope) }

    let(:envelope) do
      Fountain::EnvelopeBuilder.build do |builder|
        builder.payload = payload
      end
    end

    let(:payload) { ItemsCheckedIn.new(SecureRandom.uuid, 100) }

    it_should_behave_like 'an envelope'
  end
end
