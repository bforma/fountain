module Fountain::Repository
  class StubAggregate
    include Fountain::Domain::AggregateRoot

    attr_reader :id, :version

    def initialize(id = SecureRandom.uuid, version = nil)
      @id = id
      @version = version
    end
  end

  class SomeOtherAggregate
    include Fountain::Domain::AggregateRoot

    attr_reader :id, :version

    def initialize(id = SecureRandom.uuid)
      @id = id
    end
  end
end
