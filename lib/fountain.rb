require 'adamantium'
require 'logger'
require 'securerandom'

require 'fountain/version'

require 'fountain/envelope'
require 'fountain/envelope_builder'
require 'fountain/errors'
require 'fountain/support'

# Core components
require 'fountain/configuration'
require 'fountain/domain'
require 'fountain/event'
require 'fountain/repository'
require 'fountain/session'

module Fountain
  extend Configuration
end
