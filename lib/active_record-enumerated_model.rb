require 'active_record'
require 'active_record-readonly_model'
require 'active_record-enumerated_model/version'

module ActiveRecord
  module EnumeratedModel
    class UnknownAttributeError < StandardError; end
    class NilConstantError < StandardError; end

    module ClassMethods
      def create_enumeration_constants(constant_attribute = :name)
        self.all.each do |instance|
          constant_attribute = constant_attribute.to_s
          unless instance.attributes.include?(constant_attribute)
            raise UnknownAttributeError.new("Tried to create constants on the #{constant_attribute} attribute, but it doesn't exist on this model")
          end
          attribute_value = instance.attributes[constant_attribute]
          if attribute_value.blank?
            raise NilConstantError.new("Encountered a nil value on the #{constant_attribute} attribute and can't create a constant")
          end
          const = attribute_value.underscore.upcase
          const.gsub!(/\s/, '_')
          const.gsub!(/^[^A-Z]{1}/, '')
          const.gsub!(/[^A-Z_]/, '')
          const.gsub!(/[^A-Z]$/, '')
          unless self.const_defined?(const)
            self.const_set(const, instance)
          else
            raise RuntimeError.new("Constant #{self.to_s}::#{const} has already been defined")
          end
        end
      end

      # TODO: add a bypass method that:
      #  - calls ActiveRecord::ReadonlyModel.bypass
      #  - reloads the enumeration
    end

    def self.included(caller)
      caller.extend(ClassMethods)
      caller.send(:include, ActiveRecord::ReadonlyModel)
    end
  end
end
