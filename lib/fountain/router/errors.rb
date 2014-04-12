module Fountain
  module Router
    DuplicateHandlerError = Class.new(NonTransientError)
    NoHandlerError = Class.new(NonTransientError)
    ParameterResolutionError = Class.new(NonTransientError)
  end
end
