require 'simplecov'
require 'stringio'

SimpleCov.start

# Load all support files
Dir['./spec/support/**/*.rb'].sort.each do |path|
  require path
end

require 'fountain'

Fountain.configure do |config|
  config.logger = Logger.new(StringIO.new)
end
