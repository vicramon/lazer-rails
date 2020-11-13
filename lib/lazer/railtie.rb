module Lazer
  class Railtie < Rails::Railtie
    initializer "my_railtie.configure_rails_initialization" do
      # class ActiveRecord::Base
      #   def hello
      #     puts 'hi'
      #   end
      # end
      #   def scope(name, options={})
      #     (@__scopes__ ||= []) << [name, options]
      #     super
      #   end
      # end)
    end
  end
end
