require 'logger'
require 'securerandom'

# Third-party dependencies
require 'adamantium'
require 'equalizer'
require 'thread_safe'

# Core dependencies
require 'fountain/version'

require 'fountain/envelope'
require 'fountain/envelope_builder'
require 'fountain/errors'
require 'fountain/support'

# Core components
require 'fountain/configuration'
require 'fountain/domain'
require 'fountain/event'
require 'fountain/session'
require 'fountain/repository'
require 'fountain/serializer'

module Fountain
  extend Configuration
end
