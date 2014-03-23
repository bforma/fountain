module Fountain
  module Event
    # Thread-safe implementation of an event bus that broadcasts all published events to all
    # listeners subscribed to the bus
    #
    # Asynchronous handling is left up to the listeners to implement
    class SimpleEventBus < EventBus
      include Loggable

      def initialize
        @listeners = ConcurrentSet.new
      end

      # @param [Envelope...] events
      # @return [void]
      def publish(*events)
        events.flatten!

        unless @listeners.empty?
          events.each do |event|
            @listeners.each do |listener|
              if logger.debug?
                logger.debug "Dispatching event [#{event.payload_type.name}] to [#{listener.class.name}]"
              end

              listener.call(event)
            end
          end
        end
      end

      # @param [Object] listener
      # @return [void]
      def subscribe(listener)
        type = listener_type(listener)
        if @listeners.add?(listener)
          logger.debug "Subscribed listener [#{type.name}]"
        else
          logger.info "Listener not added, already subscribed [#{type.name}]"
        end
      end

      # @param [Object] listener
      # @return [void]
      def unsubscribe(listener)
        type = listener_type(listener)
        if @listeners.delete?(listener)
          logger.debug "Unsubscribed listener [#{type.name}]"
        else
          logger.info "Listener not removed, already unsubscribed [#{type.name}]"
        end
      end

      private

      # @param [Object] listener
      # @return [Class]
      def listener_type(listener)
        if listener.respond_to?(:proxied_type)
          listener.proxied_type
        else
          listener.class
        end
      end
    end # SimpleEventBus
  end # Event
end
