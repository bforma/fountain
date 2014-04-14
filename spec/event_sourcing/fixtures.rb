module Fountain::EventSourcing

  ItemCreated = Struct.new(:id)
  ItemsCheckedIn = Struct.new(:id, :quantity)
  ItemDeleted = Struct.new(:id)

  class InventoryItem
    include AggregateRoot

    attr_reader :quantity

    def initialize(id)
      apply(ItemCreated.new(id))
    end

    def check_in(quantity)
      apply(ItemsCheckedIn.new(id, quantity))
    end

    def delete
      apply(ItemDeleted.new(id)) unless deleted?
    end

    route_event ItemCreated do |event|
      @id = event.id
      @quantity = 0
    end

    route_event ItemsCheckedIn do |event|
      @quantity += event.quantity
    end

    route_event ItemDeleted do |event|
      mark_deleted
    end
  end

end
