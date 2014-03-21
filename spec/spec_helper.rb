require 'simplecov'
require 'stringio'

SimpleCov.start

require 'fountain'

Fountain.configure do |config|
  config.logger = Logger.new(StringIO.new)
end
