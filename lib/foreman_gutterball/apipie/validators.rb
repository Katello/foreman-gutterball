module ForemanGutterball
  module Apipie
    module Validators
      class DateValidator < ::Apipie::Validator::BaseValidator
        def initialize(param_description, argument)
          super(param_description)
          @type = argument
        end

        def validate(value)
          return false if value.nil?
          return false unless value =~ /\A\d{4}(-\d{1,2}){2}\z/
          begin
            Date.parse(value) # make sure this is a valid date and not 2015-02-45, etc.
          rescue
            return false
          end
          true
        end

        def self.build(param_description, argument, _options, _block)
          if argument == Date
            new(param_description, argument)
          end
        end

        def description
          "Must be a #{@type} in the form of YYYY-MM-DD."
        end
      end
    end
  end
end
