require 'logger'
require 'securerandom'

# Third-party dependencies
require 'active_support/concern'
require 'adamantium'
require 'equalizer'
require 'thread_safe'

# Core dependencies
require 'fountain/version'

require 'fountain/support'
require 'fountain/core_ext/class'

require 'fountain/envelope'
require 'fountain/envelope_builder'
require 'fountain/errors'

# Core components
require 'fountain/command'
require 'fountain/configuration'
require 'fountain/domain'
require 'fountain/event'
require 'fountain/session'
require 'fountain/repository'
require 'fountain/router'
require 'fountain/serializer'

require 'fountain/event_sourcing'
require 'fountain/event_store'

module Fountain
  extend Configuration
end
