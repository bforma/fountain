require 'spec_helper'

class InventoryItem
  include Fountain::Domain::AggregateRoot

  ItemCreated = Struct.new(:id)
  ItemsCheckedIn = Struct.new(:id, :quantity)

  def initialize(id)
    @id = id
    @quantity = 0

    register_event(ItemCreated.new(id))
  end

  def check_in(quantity)
    @quantity += quantity
    register_event(ItemsCheckedIn.new(id, quantity))
  end
end
