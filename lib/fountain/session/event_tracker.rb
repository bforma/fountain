module Fountain
  module Session
    class EventTracker
      include Enumerable
      include Loggable

      def initialize
        @events = {}
        @publishing = false
      end

      # Clears all events staged for publication
      # @return [void]
      def clear
        @events.clear
      end

      # @yield [Envelope]
      # @return [Enumerator]
      def each(&block)
        return to_enum(:each) unless block_given?

        @events.each_value do |events|
          events.each do |event|
            yield event
          end
        end
      end

      # Returns true if no events are staged for publication
      # @return [Boolean]
      def empty?
        @events.empty?
      end

      # Stages the given event for publication on the given event bus
      #
      # @param [Envelope] event
      # @param [EventBus] event_bus
      # @return [void]
      def stage(event, event_bus)
        if logger.debug?
          logger.debug "Staging event [#{event.payload_type.name}] for publication on [#{event_bus.class.name}]"
        end

        events_for(event_bus).push(event)
      end

      # Continuously publishes registered events onto their respective event buses
      # @return [void]
      def publish
        if @publishing
          logger.debug 'Publication is in-progress'
          return
        end

        logger.debug 'Starting event publication'
        @publishing = true

        until @events.empty?
          event_bus, events = @events.first

          if logger.debug?
            events.each do |event|
              logger.debug "Publishing event [#{event.payload_type.name}] on [#{event_bus.class.name}]"
            end
          end

          @events.delete(event_bus)
          event_bus.publish(*events)
        end

        logger.debug 'All events successfully published'
        @publishing = false
      end

      private

      # @param [EventBus] event_bus
      # @return [Array]
      def events_for(event_bus)
        @events[event_bus] ||= []
      end
    end # EventTracker
  end # Session
end
