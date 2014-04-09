module Fountain
  module Repository
    AggregateNotFoundError = Class.new(NonTransientError)
    ConcurrencyError = Class.new(TransientError)
    ConflictingModificationError = Class.new(NonTransientError)
    ConflictingAggregateVersionError = Class.new(ConflictingModificationError)
  end
end
