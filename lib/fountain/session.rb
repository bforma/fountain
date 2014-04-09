require 'fountain/session/aggregate_tracker'
require 'fountain/session/event_tracker'
require 'fountain/session/transaction_manager'
require 'fountain/session/unit'
require 'fountain/session/unit_listener'
require 'fountain/session/unit_listener_list'
require 'fountain/session/unit_stack'

module Fountain
  module Session
    # @return [Unit]
    def self.current_unit
      UnitStack.current
    end
  end
end
