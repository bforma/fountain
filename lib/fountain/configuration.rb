module Fountain
  module Configuration
    # @return [Logger]
    attr_accessor :logger

    # @yield [Configuration]
    # @return [undefined]
    def configure
      yield self if block_given?
      populate_defaults
    end

    # @return [undefined]
    def populate_defaults
      @logger ||= Logger.new($stdout)
    end
  end
end
