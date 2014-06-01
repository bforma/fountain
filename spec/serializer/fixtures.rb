module Fountain::Serializer

  # Super simple event to be serialized
  ItemsCheckedIn = Struct.new(:id, :quantity)

  # Useless converters to demonstrate converters
  class StringToByteArrayConverter < Converter
    def convert_content(original)
      original.bytes.to_a
    end

    def source_type
      String
    end

    def target_type
      Array
    end
  end

  class ByteArrayToStringConverter < Converter
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

end
