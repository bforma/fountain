module Fountain
  module Session
    # Mechanism for managing the unit of work stack
    #
    # Components that are aware of transactional boundaries can register and clear units of work
    # for the calling thread.
    module UnitStack
      extend self

      # @return [Boolean]
      def active?
        stack.size > 0
      end

      # @raise [InvalidStateError] If no active unit registered
      # @return [Unit]
      def current
        if stack.empty?
          raise InvalidStateError, 'No active unit registered'
        end

        stack.last
      end

      # Commits the active unit of work
      #
      # @raise [InvalidStateError] If no active unit registered
      # @return [void]
      def commit
        current.commit
      end

      # Rolls back the active unit of work
      #
      # @raise [InvalidStateError] If no active unit registered
      # @return [void]
      def rollback
        current.rollback
      end

      # Rolls back all units of work in the stack
      # @return [void]
      def rollback_all
        rollback while active?
      end

      # Sets the active unit of work
      #
      # @param [Unit] unit
      # @return [void]
      def push(unit)
        stack.push(unit)
      end

      # Clears the active unit of work
      #
      # @raise [ArgumentError] If given unit is not the active unit
      # @param [Unit] unit
      # @return [void]
      def clear(unit)
        unless stack.last == unit
          raise ArgumentError, 'The given unit is not the active unit'
        end

        stack.pop
      end

      # Clears the entire unit of work stack
      #
      # @api private
      # @return [void]
      def clear_all
        stack.clear
      end

      private

      # @return [Array]
      def stack
        Threaded[:unit] ||= []
      end
    end # UnitStack
  end # Session
end
