require 'adamantium'
require 'logger'
require 'securerandom'

require 'fountain/version'

require 'fountain/envelope'
require 'fountain/envelope_builder'
require 'fountain/errors'
require 'fountain/loggable'
require 'fountain/threaded'

require 'fountain/configuration'
require 'fountain/domain'

module Fountain
  extend Configuration
end
