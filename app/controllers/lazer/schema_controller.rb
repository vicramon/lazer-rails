require_dependency "lazer/application_controller"

module Lazer
  class SchemaController < ApplicationController

    def show
      authenticate!; return if performed?

      Rails.application.eager_load!
      models = ActiveRecord::Base.descendants

      result = models.map do |model|
        model_data = {
          name: model.name,
          table: model.table_name,
        }
        associations = []
        begin
        model.reflect_on_all_associations.each do |association|
          associations << {
            marcro: association.macro,
            name: association.name,
            options: association.options,
            table: association.table_name,
          }
        end
        rescue => e
          logger.debug "error #{e.message}"
        end
        model_data[:associations] = associations
        model_data
      end

      render json: result
    end

    private

    def authenticate!
      if params[:lazer_key].blank?
        render json: "Missing lazer_key param", status: 401
        return
      end
      if ENV["LAZER_KEY"].blank?
        render json: "You need to set your LAZER_KEY env variable", status: 401
        return
      end
      if params[:lazer_key] != ENV["LAZER_KEY"]
        render json: "lazer_key param doesn't match LAZER_KEY env variable", status: 401
        return
      end
    end

  end
end
