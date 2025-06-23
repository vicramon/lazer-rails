require "rails/railtie"

module Lazer
  class Railtie < ::Rails::Railtie
    initializer "lazer.track_scopes" do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.include(Lazer::TrackScopes)
      end
    end
  end
end
