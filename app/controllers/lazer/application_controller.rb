module Lazer
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    before_action :authenticate!

    def authenticate!
      if params[:api_key].blank?
        render json: "Missing api_key param", status: 401
        return
      end
      if ENV["LAZER_KEY"].blank?
        render json: "You need to set your LAZER_KEY env variable", status: 401
        return
      end
      if params[:api_key] != ENV["LAZER_KEY"]
        render json: "api_key param doesn't match LAZER_KEY env variable", status: 401
        return
      end
    end
  end
end
