module Fountain
  class EnvelopeBuilder
    # @yield [EnvelopeBuilder]
    # @return [Envelope]
    def self.build
      builder = new

      yield builder if block_given?

      builder.populate_defaults
      builder.build
    end

    # @return [String]
    attr_accessor :id

    # @return [Hash]
    attr_accessor :headers

    # @return [Object]
    attr_accessor :payload

    # @return [Time]
    attr_accessor :timestamp

    # @return [Envelope]
    def build
      Envelope.new(id, headers, payload, timestamp)
    end

    # @return [undefined]
    def populate_defaults
      @id ||= SecureRandom.uuid
      @headers ||= {}
      @timestamp ||= Time.now
    end
  end
end
