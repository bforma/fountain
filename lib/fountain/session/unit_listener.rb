module Fountain
  module Session
    # Listener that is notified of state changes for a unit of work
    class UnitListener
      # @param [Unit] unit
      # @param [Envelope] event
      # @return [Envelope]
      def on_event_registered(unit, event)
        event
      end

      # @param [Unit] unit
      # @param [Enumerable] aggregates
      # @param [Enumerable] events
      # @return [void]
      def on_prepare_commit(unit, aggregates, events)
        # This method is intentionally empty
      end

      # @param [Unit] unit
      # @param [Object] transaction
      # @return [void]
      def on_prepare_transaction_commit(unit, transaction)
        # This method is intentionally empty
      end

      # @param [Unit] unit
      # @return [void]
      def after_commit(unit)
        # This method is intentionally empty
      end

      # @param [Unit] unit
      # @param [Throwable] cause
      # @return [void]
      def on_rollback(unit, cause)
        # This method is intentionally empty
      end

      # @param [Unit] unit
      # @return [void]
      def on_cleanup(unit)
        # This method is intentionally empty
      end
    end # UnitListener
  end # Session
end
