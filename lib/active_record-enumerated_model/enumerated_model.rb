module ActiveRecord
  module EnumeratedModel
    class UnknownAttributeError < StandardError; end
    class NilConstantError < StandardError; end

    module ClassMethods

      def create_enumeration_constants(enumeration_attribute = :name, options = {:force => false})
        @enumeration_attribute = enumeration_attribute
        @enumerated_constants = [] if @enumerated_constants.blank?
        clear_existing_constants if options[:force]
        attribute = enumeration_attribute.to_s

        self.all.each do |instance|
          unless instance.attributes.include?(attribute)
            raise UnknownAttributeError.new("Tried to create constants on the #{attribute} attribute, but it doesn't exist on this model")
          end
          value = instance.attributes[attribute]
          if value.blank?
            raise NilConstantError.new("Encountered a nil value on the #{attribute} attribute and can't create a constant")
          end
          const = ActiveRecord::EnumeratedModel.constant_friendly_string(value)
          if self.const_defined?(const)
            if options[:force]
              self.send(:remove_const, const)
            else
              raise RuntimeError.new("Constant #{self.to_s}::#{const} has already been defined")
            end
          end
          self.const_set(const, instance)
          @enumerated_constants << const
        end
      end

      def clear_existing_constants
        unless @enumerated_constants.blank?
          @enumerated_constants.each do |existing_constant|
            if self.const_defined?(existing_constant)
              self.send(:remove_const, existing_constant)
            end
          end
        end
      end

      def bypass_readonly(&block)
        ActiveRecord::ReadonlyModel.bypass do
          yield
        end
        # regenerate constants
        create_enumeration_constants(@enumeration_attribute, :force => true)
      end
    end

    def self.included(caller)
      caller.extend(ClassMethods)
      caller.send(:include, ActiveRecord::ReadonlyModel)
      if caller.attribute_names.include? 'name'
        caller.create_enumeration_constants :name
      end
    end

    def self.constant_friendly_string(str)
      const = str.underscore.upcase
      const.gsub!(/\s/, '_')
      const.gsub!(/^[^A-Z]{1}/, '')
      const.gsub!(/[^A-Z_]/, '')
      const.gsub!(/[^A-Z]$/, '')
      const
    end

  end
end
