require 'spec_helper'

module Fountain::Serializer
  describe MarshalSerializer do

    # Sample event being serialized
    ItemsCheckedIn = Struct.new(:id, :quantity)

    # Useless example converters
    StringToByteArrayConverter = Class.new(Converter) do
      def convert_content(original)
        original.bytes
      end

      def source_type
        String
      end

      def target_type
        Array
      end
    end

    ByteArrayToStringConverter = Class.new(Converter) do
      def convert_content(original)
        original.pack('C*').force_encoding('UTF-8')
      end

      def source_type
        Array
      end

      def target_type
        String
      end
    end

    subject { MarshalSerializer.new(converter_factory) }
    let(:converter_factory) { ConverterFactory.new }

    let(:event) { ItemsCheckedIn.new(SecureRandom.uuid, rand(100..500)) }

    describe '#serialize' do
      it 'serializes an object using Marshal' do
        serialized_object = subject.serialize(event, String)
        deserialized = subject.deserialize(serialized_object)

        expect(deserialized).to be_an(ItemsCheckedIn)
        expect(deserialized.id).to eql(event.id)
        expect(deserialized.quantity).to eql(event.quantity)
      end

      it 'converts the output if necessary' do
        converter_factory.register(ByteArrayToStringConverter.new)
        converter_factory.register(StringToByteArrayConverter.new)

        serialized_object = subject.serialize(event, Array)
        deserialized = subject.deserialize(serialized_object)

        expect(deserialized).to be_an(ItemsCheckedIn)
        expect(deserialized.id).to eql(event.id)
        expect(deserialized.quantity).to eql(event.quantity)
      end

      it 'uses revision resolver if present' do
        revision = '1.0'

        subject.revision_resolver = FixedRevisionResolver.new(revision)

        serialized_object = subject.serialize(event, String)
        expect(serialized_object.type.revision).to eql(revision)
      end
    end

    describe '#can_serialize_to?' do
      it 'returns true if conversion available' do
        converter_factory.register(StringToByteArrayConverter.new)
        expect(subject.can_serialize_to?(Array)).to be_true
      end

      it 'returns false if conversion not available' do
        expect(subject.can_serialize_to?(Array)).to be_false
      end

      it 'returns true if native content type' do
        expect(subject.can_serialize_to?(String)).to be_true
      end
    end

  end
end
