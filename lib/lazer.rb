require "lazer/engine"
require "active_support"

module Lazer
  # Your code goes here...
end

ActiveSupport.on_load(:active_record) do

  ActiveRecord::Scoping::Named::ClassMethods.prepend(Module.new do
    def scope(name, options={})
      (@__scopes__ ||= []) << [name, options]
      super
    end
  end)
end
