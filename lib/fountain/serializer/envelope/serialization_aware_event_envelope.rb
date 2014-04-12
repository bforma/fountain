module Fountain
  module Serializer
    class SerializationAwareEventEnvelope < SerializationAwareEnvelope
      # Delegators for event envelope attributes
      def_delegators :@envelope, :sequence_number
    end # SerializationAwareEventEnvelope
  end # Serializer
end
