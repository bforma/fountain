module Fountain
  module Router
    # @abstract
    class ParameterResolver
      # @abstract
      # @param [Integer] index
      # @param [Symbol] name
      # @return [Boolean]
      def can_resolve?(index, name)
        false
      end

      # @abstract
      # @param [Envelope] envelope
      # @return [Object]
      def resolve(envelope)
        # This method is intentionally blank
      end
    end # ParameterResolver

    class PayloadParameterResolver < ParameterResolver
      # @param [Integer] index
      # @param [Symbol] name
      # @return [Boolean]
      def can_resolve?(index, name)
        index == 0
      end

      # @param [Envelope] envelope
      # @return [Object]
      def resolve(envelope)
        envelope.payload
      end
    end # PayloadParameterResolver

    class EnvelopeParameterResolver < ParameterResolver
      # @param [Integer] index
      # @param [Symbol] name
      # @return [Boolean]
      def can_resolve?(index, name)
        :envelope == name
      end

      # @param [Envelope] envelope
      # @return [Object]
      def resolve(envelope)
        envelope
      end
    end # EnvelopeParameterResolver

    class HeadersParameterResolver < ParameterResolver
      # @param [Integer] index
      # @param [Symbol] name
      # @return [Boolean]
      def can_resolve?(index, name)
        :headers == name
      end

      # @param [Envelope] envelope
      # @return [Object]
      def resolve(envelope)
        envelope.headers
      end
    end # HeadersParameterResolver

    class TimestampParameterResolver < ParameterResolver
      # @param [Integer] index
      # @param [Symbol] name
      # @return [Boolean]
      def can_resolve?(index, name)
        :timestamp == name
      end

      # @param [Envelope] envelope
      # @return [Object]
      def resolve(envelope)
        envelope.timestamp
      end
    end # TimestampParameterResolver

    class SequenceNumberParameterResolver < ParameterResolver
      # @param [Integer] index
      # @param [Symbol] name
      # @return [Boolean]
      def can_resolve?(index, name)
        :sequence_number == name
      end

      # @param [Envelope] envelope
      # @return [Object]
      def resolve(envelope)
        envelope.sequence_number
      end
    end # SequenceNumberParameterResolver
  end # Router
end
