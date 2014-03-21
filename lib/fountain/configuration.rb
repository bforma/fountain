module Fountain
  module Configuration
    # @return [Logger]
    attr_accessor :logger

    # @yield [Configuration]
    # @return [void]
    def configure
      yield self if block_given?
      populate_defaults
    end

    # @return [void]
    def populate_defaults
      @logger ||= Logger.new($stdout)
    end
  end
end
