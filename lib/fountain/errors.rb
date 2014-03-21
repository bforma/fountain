module Fountain
  # Base class for any framework-related errors
  BaseError = Class.new(StandardError)

  # Raised when an operation failed due to an error that cannot be resolved without intervention.
  # Retrying the operation that raised this error will most likely result in the same error
  # being raised.
  #
  # This is usually caused by programming bugs or version conflicts
  NonTransientError = Class.new(BaseError)

  # Raised when an operation failed due to an error that likely can be resolved by retrying the
  # operation. Typically the cause of the error is of temporary nature and may be resolved without
  # intervention.
  TransientError = Class.new(BaseError)

  # Raised when an operation failed due to the application being in an invalid state
  InvalidStateError = Class.new(NonTransientError)
end
