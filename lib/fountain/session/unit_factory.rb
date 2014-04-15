module Fountain
  module Session
    class UnitFactory
      # @param [TransactionManager] transaction_manager
      def initialize(transaction_manager = nil)
        @transaction_manager = transaction_manager
      end

      # @return [Unit]
      def call
        Unit.start(@transaction_manager)
      end
    end # UnitFactory
  end # Session
end
