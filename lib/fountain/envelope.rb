module Fountain
  class Envelope
    include Adamantium

    # @param [Object] object
    # @return [Envelope]
    def self.as_message(object)
      if object.is_a?(self)
        object
      else
        build do |builder|
          builder.payload = object
        end
      end
    end

    # @return [Class]
    def self.builder_type
      EnvelopeBuilder
    end

    # @yield [EnvelopeBuilder]
    # @return [Envelope]
    def self.build(&block)
      builder_type.build(&block)
    end

    # @return [String]
    attr_reader :id

    # @return [Hash]
    attr_reader :headers

    # @return [Object]
    attr_reader :payload

    # @return [Time]
    attr_reader :timestamp

    # @param [String] id
    # @param [Hash] headers
    # @param [Object] payload
    # @param [Time] timestamp
    # @return [void]
    def initialize(id, headers, payload, timestamp)
      @id = id
      @headers = headers
      @payload = payload
      @timestamp = timestamp
    end

    # @return [Class]
    def payload_type
      @payload.class
    end

    # @param [Hash] headers
    # @return [Envelope]
    def and_headers(headers)
      return self if headers.empty?
      build_duplicate(@headers.merge(headers))
    end

    # @param [Hash] headers
    # @return [Envelope]
    def with_headers(headers)
      return self if @headers === headers
      build_duplicate(headers)
    end

    # @return [Class]
    def builder_type
      self.class.builder_type
    end

    private

    # @param [Hash] headers
    # @return [Envelope]
    def build_duplicate(headers)
      builder = builder_type.new
      populate_duplicate(builder, headers)
      builder.build
    end

    # @param [EnvelopeBuilder] builder
    # @param [Hash] headers
    # @return [void]
    def populate_duplicate(builder, headers)
      builder.id = @id
      builder.headers = headers
      builder.payload = @payload
      builder.timestamp = @timestamp
    end
  end
end
