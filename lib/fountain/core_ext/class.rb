require 'active_support/core_ext/array/extract_options'

class Class
  # @param [Symbol...] syms
  # @return [void]
  def inheritable_reader(*syms)
    options = syms.extract_options!
    syms.each do |sym|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def self.#{sym}                               # def self.event_router
          unless @#{sym}                              #   unless @event_router
            if superclass.respond_to?(:#{sym})        #     if superclass.respond_to?(:event_router)
              @#{sym} = superclass.#{sym}.clone       #       @event_router = superclass.event_router.clone
            end                                       #     end
          end                                         #   end
                                                      #
          @#{sym}                                     #   @event_router
        end                                           # end
      RUBY_EVAL

      unless options[:instance_reader] == false || options[:instance_accessor] == false
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def #{sym}                                  # def event_router
            self.class.#{sym}                         #   self.class.event_router
          end                                         # end
        RUBY_EVAL
      end
    end
  end

  # @yield
  # @param [Symbol...] syms
  # @return [void]
  def inheritable_writer(*syms, &block)
    options = syms.extract_options!
    syms.each do |sym|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def self.#{sym}=(value)                       # def self.event_router=(value)
          @#{sym} = value                             #   @event_router = value
        end                                           # end
      RUBY_EVAL

      unless options[:instance_writer] == false || options[:instance_accessor] == false
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def #{sym}=(value)                          # def event_router=(value)
            self.class.#{sym} = value                 #   self.class.event_router = value
          end                                         # end
        RUBY_EVAL
      end

      send("#{sym}=", yield) if block_given?
    end
  end

  # @yield
  # @param [Symbol...] syms
  # @return [void]
  def inheritable_accessor(*syms, &block)
    inheritable_reader(*syms)
    inheritable_writer(*syms, &block)
  end
end
