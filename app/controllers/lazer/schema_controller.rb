require_dependency "lazer/application_controller"

module Lazer
  class SchemaController < ApplicationController

    # todo: page this endpoint so it won't hit as hard
    def show
      authenticate!; return if performed?

      Rails.application.eager_load!
      models = ActiveRecord::Base.descendants

      result = {}

      result[:models] = models.map do |model|
        parse_model(model)
      end

      # not necessarily needed, can get tables directly from the db
      # result[:raw_tables] = gather_tables

      render json: result.to_json
    end

    private

    def connection
      ActiveRecord::Base.connection
    end

    def gather_tables
      connection.tables.map do |table_name|
        { table_name =>
          connection.columns(table_name).map do |column|
            {
              name: column.name,
              type: column.type,
            }
          end
        }
      end
    end

    def parse_model(model)
      logger.debug "Parsing: #{model.name}"
      # return {} if model.name == "ActiveRecord::SchemaMigration"
      model_data = {
        name: model.name,
        table: model.table_name,
      }
      associations = []
      model.reflect_on_all_associations.each do |association|
        associations << {
          marcro: association.macro,
          name: association.name,
          options: association.options,
          table: association.table_name,
        }
      end
      # model_data[:columns] = model.column_names
      # model_data[:scopes] = model.instance_variable_get(:@__scopes__)
      model_data[:associations] = associations
      return model_data
    rescue => e
      logger.debug "error parsing model #{model.name}: #{e.message}"
      return {}
    end

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
