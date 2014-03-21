module Fountain
  # Provides uniform access to the framework logger
  module Loggable
    # @return [Logger]
    def logger
      Fountain.logger
    end
  end
end
