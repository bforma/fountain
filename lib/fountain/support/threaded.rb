module Fountain
  # Provides uniform access to namespaced thread-local storage
  module Threaded
    extend self
    extend Forwardable

    # @return [Hash]
    def current
      Thread.current[:fountain] ||= {}
    end

    def_delegators :current, :[], :[]=
  end
end
