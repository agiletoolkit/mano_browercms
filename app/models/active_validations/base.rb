require 'active_record/validations'
module ActiveValidations
  class Base
    #Accessor for rails errors
    attr_accessor :errors
    
    def initialize(opts={})
      @errors = ActiveRecord::Errors.new(self)
      opts.each_pair do |attr_name, value|
        self.send("#{attr_name}=", value)
      end
    end

    # # copied from ActiveRecord::Base
    def self.human_attribute_name(attribute_key_name)
      attribute_key_name.humanize
    end
    def self.human_name(options = {})
      defaults = self_and_descendants_from_active_record.map do |klass|
        :"#{klass.name.underscore}"
      end 
      defaults << self.name.humanize
      I18n.translate(defaults.shift, {:scope => [:activerecord, :models], :count => 1, :default => defaults}.merge(options))
    end
    def self.self_and_descendants_from_active_record
      [self]
    end

    def save
    end
    def save!
    end
    def new_record?
      return false
    end
    def update_attribute
    end

    # needed for validates_numericality_of
    def method_missing( method_id, *args )
      match = method_id.to_s.match(/_before_type_cast/)
      if match
        attr_name = match.pre_match
        return self.send(attr_name) if self.respond_to?(attr_name)
      end
      super
    end
    
    include ActiveRecord::Validations
  end
end