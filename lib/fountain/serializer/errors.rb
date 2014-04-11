module Fountain
  module Serializer
    UnknownSerializedTypeError = Class.new(NonTransientError)
    ConversionError = Class.new(NonTransientError)
  end
end
