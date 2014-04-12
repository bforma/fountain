require 'spec_helper'
require 'serializer/fixtures'

module Fountain::Serializer
  describe LazyObject do

    let(:serializer) { MarshalSerializer.new(ConverterFactory.new) }
    let(:event) { ItemsCheckedIn.new(SecureRandom.uuid, 100) }

    it 'only deserializes an object once' do
      serialized_object = serializer.serialize(event, String)
      lazy_object = LazyObject.new(serialized_object, serializer)

      expect(lazy_object.serialized_object).to be(serialized_object)
      expect(lazy_object.serializer).to be(serializer)
      expect(lazy_object.type).to eql(event.class)

      expect(lazy_object).to_not be_deserialized

      deserialized_a = lazy_object.deserialized
      deserialized_b = lazy_object.deserialized

      expect(deserialized_a).to be(deserialized_b)
      expect(deserialized_a).to eql(event)

      expect(lazy_object).to be_deserialized
    end

  end
end
