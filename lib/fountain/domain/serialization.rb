module Fountain
  module Domain
    # Provides mechanism for excluding transient fields from serialization
    module Serialization
      # Dumps the state of this aggregate for marshalling
      # @return [Hash]
      def marshal_dump
        Hash[state_properties.map { |name| [name, instance_variable_get(name)] }]
      end

      # Restores the state of this aggregate from marshalling
      #
      # @param [Hash] state
      # @return [void]
      def marshal_load(state)
        state.each do |name, value|
          instance_variable_set(name, value)
        end
      end

      # Returns the instance variables that should be serialized
      # @return [Enumerable]
      def state_properties
        instance_variables.sort - excluded_properties
      end

      # Override this to exclude any transient properties from serialization
      # @return [Enumerable]
      def excluded_properties
        []
      end

      alias_method :to_yaml_properties, :state_properties
    end
  end
end
