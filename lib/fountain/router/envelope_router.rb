require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/core_ext/array/extract_options'

module Fountain
  module Router
    class EnvelopeRouter
      # @return [Boolean]
      attr_accessor :auto_resolve

      # @return [Boolean]
      attr_accessor :duplicates_allowed

      def initialize
        @auto_resolve = true
        @duplicates_allowed = true
        @handlers = []
      end

      # Adds the given handler to the router for a given payload type
      #
      # @yield [Object...]
      # @param [Class] payload_type
      # @param [Hash] options
      # @return [void]
      def add_route(payload_type, *args, &block)
        options = args.extract_options!
        handler = create_handler(payload_type, options, &block)

        unless @duplicates_allowed
          if @handlers.include?(handler)
            # TODO More detailed error message
            raise DuplicateHandlerError
          end
        end

        @handlers.push(handler)
        @handlers.sort!
      end


      # Routes the given envelope to the first matching handler
      #
      # @param [Object] target
      # @param [Envelope] envelope
      # @return [Object] Result of the handler invocation
      def route_first(target, envelope)
        handler = find_handler(envelope)
        if handler
          handler.invoke(target, envelope)
        end
      end

      # Routes the given envelope to the first matching handler
      #
      # @raise [NoHandlerError] If envelope could not be routed
      # @param [Object] target
      # @param [Envelope] envelope
      # @return [Object] Result of the handler invocation
      def route_first!(target, envelope)
        handler = find_handler(envelope)

        if handler
          handler.invoke(target, envelope)
        else
          raise NoHandlerError
        end
      end

      # Routes the given envelope to any matching handlers
      #
      # @param [Object] target
      # @param [Envelope] envelope
      # @return [void]
      def route_all(target, envelope)
        @handlers.each do |handler|
          if handler.match?(envelope)
            handler.invoke(target, envelope)
          end
        end
      end

      private

      # @param [Envelope] envelope
      # @return [EnvelopeHandler]
      def find_handler(envelope)
        @handlers.find do |handler|
          handler.match?(envelope)
        end
      end

      # @raise [ArgumentError]
      # @param [Class] payload_type
      # @param [Object] options
      # @return [EnvelopeHandler]
      def create_handler(payload_type, options, &block)
        options.reverse_update(auto_resolve: auto_resolve)
        to = options.delete(:to)

        if to
          if block
            raise ArgumentError, 'Both block and method were given'
          end
        elsif block
          to = block
        else
          raise ArgumentError, 'Either block or method name must be provided'
        end

        EnvelopeHandler.new(payload_type, to, options)
      end
    end # EnvelopeRouter
  end # Router
end
