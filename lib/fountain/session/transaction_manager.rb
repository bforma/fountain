module Fountain
  module Session
    # @abstract
    class TransactionManager
      NULL_TRANSACTION = Object.new

      # @abstract
      # @return [Object]
      def start
        NULL_TRANSACTION
      end

      # @abstract
      # @param [Object] transaction
      # @return [void]
      def commit(transaction)
        # This method is intentionally left blank
      end

      # @abstract
      # @param [Object] transaction
      # @return [void]
      def rollback(transaction)
        # This method is intentionally left blank
      end
    end # TransactionManager
  end # Session
end
