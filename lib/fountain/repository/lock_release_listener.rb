module Fountain
  module Repository
    class LockReleaseListener < Session::UnitListener
      def initialize(lock_manager, aggregate_id)
        @lock_manager = lock_manager
        @aggregate_id = aggregate_id
      end

      def on_cleanup(unit)
        @lock_manager.release_lock(@aggregate_id)
      end
    end
  end
end
