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

  GameCreated = Struct.new(:id)
  DeckCreated = Struct.new(:cards)
  CardsDealt = Struct.new(:cards)

  class Game
    include AggregateRoot

    child_entity :deck

    def initialize(id, cards)
      apply(GameCreated.new(id))
      apply(DeckCreated.new(cards))
    end

    def start
      @deck.deal_cards
    end

    def cards
      @deck.cards
    end

    def dealt_cards
      @deck.dealt_cards
    end

    route_event GameCreated do |event|
      @id = event.id
    end

    route_event DeckCreated do |event|
      @deck = Deck.new(event.cards)
    end
  end

  class Deck
    include Entity

    attr_reader :cards, :dealt_cards

    def initialize(cards)
      @cards = cards
      @dealt_cards = []
    end

    def deal_cards
      apply(CardsDealt.new(@cards.slice(0, 1)))
    end

    route_event CardsDealt do |event|
      @dealt_cards.concat(event.cards)
    end
  end

end
