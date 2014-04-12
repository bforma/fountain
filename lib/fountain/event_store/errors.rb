module Fountain
  module EventStore
    EventStoreError = Class.new(NonTransientError)
    StreamNotFoundError = Class.new(EventStoreError)
  end
end
