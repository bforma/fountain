module Fountain
  module Router
    class EnvelopeHandlerScore
      include Comparable

      # @return [Integer]
      attr_reader :payload_depth

      # @return [String]
      attr_reader :payload_name

      # @param [Class] payload_type
      def initialize(payload_type)
        @payload_depth = superclass_count(payload_type)
        @payload_name = payload_type.name
      end

      # @param [EnvelopeHandlerScore] other
      # @return [Integer]
      def <=>(other)
        if @payload_depth != other.payload_depth
          @payload_depth <=> other.payload_depth
        else
          @payload_name <=> other.payload_name
        end
      end

      # @param [EnvelopeHandlerScore] other
      # @return [Boolean]
      def ==(other)
        other.is_a?(self.class) &&
          other.payload_depth == @payload_depth &&
          other.payload_name == @payload_name
      end

      alias_method :eql?, :==

      # @return [Integer]
      def hash
        @payload_depth.hash ^ @payload_name.hash
      end

      private

      # @param [Class] type
      # @return [Integer]
      def superclass_count(type)
        count = 0
        while type
          type = type.superclass
          count += 1
        end

        count
      end
    end # EnvelopeHandlerScore
  end # Router
end
