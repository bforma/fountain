module Fountain
  # Thread-safe copy-on-write set, suitable when readers outnumber writers by a wide margin
  class ConcurrentSet
    include Enumerable

    def initialize
      @elements = Set.new
      @mutex = Mutex.new
    end

    # Adds the given element to this set
    #
    # @param [Object] element
    # @return [ConcurrentSet]
    def add(element)
      update do |elements|
        elements.add(element)
      end
    end

    # Adds the given element to this set
    #
    # @param [Object] element
    # @return [ConcurrentSet] Returns nil if element already in set
    def add?(element)
      update do |elements|
        elements.add?(element)
      end
    end

    # Removes the given element from this set
    #
    # @param [Object] element
    # @return [ConcurrentSet]
    def delete(element)
      update do |elements|
        elements.delete(element)
      end
    end

    # Removes the given element from this set
    #
    # @param [Object] element
    # @return [ConcurrentSet] Returns nil if element not in set
    def delete?(element)
      update do |elements|
        elements.delete?(element)
      end
    end

    # @yield [Object]
    # @return [Enumerator]
    def each(&block)
      @elements.each(&block)
    end

    # Returns true if this set is empty
    # @return [Boolean]
    def empty?
      @elements.empty?
    end

    # Returns the number of elements in this set
    # @return [Integer]
    def size
      @elements.size
    end

    # Returns an array containing the elements in this set
    # @return [Array]
    def to_a
      @elements.to_a
    end

    private

    # Performs a synchronized update on a copy of the set, replacing the reference upon
    # completion of the operation
    #
    # @yield [Set]
    # @return [Object] Result of operation
    def update
      @mutex.synchronize do
        update = @elements.dup

        result = yield update
        @elements = update

        # Don't leak internal reference
        if result.equal? update
          result = self
        end

        result
      end
    end
  end # ConcurrentSet
end
