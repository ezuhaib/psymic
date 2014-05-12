# If the model including this concern has an
# 'options' column, this concern allows you to
# store values in it and retrieve from it just
# like regular attributes

module Optionable
  extend ActiveSupport::Concern

	module ClassMethods

		def options(hash)
			@@options = hash
			serialize :options
			options_attr_accessor
		end

		def options_attr_accessor
		  @@options.keys.each do |method_name|
		    class_eval do
		      # GETTER
		      define_method method_name do
		        self.options ||= {}
		        # Read option value from db if present
		        if !self.options[method_name].nil?
		          return self.options[method_name]
		        # Read from defaults if not present
		        else
		          return @@options[method_name]
		        end
		      end

		      # SETTER
		      define_method "#{method_name}=" do |value|
		        self.options ||= {}
		        if value == '1'
		          self.options[method_name] = true
		        elsif value == '0'
		          self.options[method_name] = false
		        else
		          self.options[method_name] = value
		        end
		      end

		    end
		  end
		end

		def option_params
  			@@options.keys
		end

	end

end