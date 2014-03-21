require 'adamantium'
require 'logger'
require 'securerandom'

require 'fountain/version'

require 'fountain/envelope'
require 'fountain/envelope_builder'
require 'fountain/errors'
require 'fountain/support'

require 'fountain/configuration'
require 'fountain/domain'
require 'fountain/event'
require 'fountain/session'

module Fountain
  extend Configuration
end
