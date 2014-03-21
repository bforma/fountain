require 'simplecov'

SimpleCov.start

require 'fountain'

class NullLogger
  def method_missing(*)
    # Just ignore any logging calls
  end
end

Fountain.configure do |config|
  config.logger = NullLogger.new
end
