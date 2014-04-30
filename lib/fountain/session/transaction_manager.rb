module Fountain
  module Session
    # Mechanism for managing transactions
    #
    # Implementations can choose whether or not to support nested transactions
    class TransactionManager
      NULL_TRANSACTION = Object.new

      # @return [Object]
      def start
        NULL_TRANSACTION
      end

      # @param [Object] transaction
      # @return [void]
      def commit(transaction)
        # This method is intentionally left blank
      end

      # @param [Object] transaction
      # @return [void]
      def rollback(transaction)
        # This method is intentionally left blank
      end
    end # TransactionManager
  end # Session
end
