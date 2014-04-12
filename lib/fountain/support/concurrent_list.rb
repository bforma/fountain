module Fountain
  # Thread-safe copy-on-write list, suitable when readers outnumber writers by a wide margin
  class ConcurrentList
    include Enumerable

    def initialize
      @elements = []
      @mutex = Mutex.new
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

    # @param [Object] element
    # @return [ConcurrentList]
    def push(element)
      update do |elements|
        elements.push(element)
      end
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

    # Performs a synchronized update on a copy of the array, replacing the reference upon
    # completion of the operation
    #
    # @yield [Array]
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
  end # ConcurrentList
end
