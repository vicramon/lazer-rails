require_dependency "lazer/application_controller"

module Lazer
  class SchemaController < ApplicationController

    def show
      require_page!; return if performed?

      Rails.application.eager_load!
      models = ActiveRecord::Base.descendants

      result = {}

      page = params[:page].to_i
      models_per_page = 30
      offset = (page - 1) * models_per_page

      models = models[offset, models_per_page] || []
      result[:models] = models.map do |model|
        parse_model(model)
      end

      # not necessarily needed, can get tables directly from the db
      # result[:raw_tables] = gather_tables

      result[:count] = models.length
      result[:page] = page
      result[:offset] = offset

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
          macro: association.macro,
          name: association.name,
          options: association.options,
          table: association.table_name,
          foreign_key: association.foreign_key,
          # to_table: association.class_name.constantize.table_name,
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

    def require_page!
      if params[:page].blank?
        render json: "You must specify a page param", status: 422
        return
      end
    end

  end
end
