require_dependency "lazer/application_controller"

module Lazer
  class ScopesController < ApplicationController

    def show
      require_page!; return if performed?

      page = params[:page].to_i
      models_per_page = 30
      offset = (page - 1) * models_per_page

      Rails.application.eager_load!
      all_models = ActiveRecord::Base.descendants.sort_by(&:name)
      paged_models = all_models[offset, models_per_page] || []

      result = {}

      result[:count] = paged_models.length
      result[:page] = page
      result[:offset] = offset
      result[:scopes] = fetch_scopes_for(paged_models)
      render json: result.to_json
    end

    def fetch_scopes_for(models)
      worked = []
      failed = []
      data = {}

      models.each do |model|
        begin
          scopes = get_scopes_for_model(model)
          if scopes.present?
            data[model.name] = {
              scopes: scopes,
              table_name: model.table_name
            }
          end
          worked << (model.respond_to?(:class_name) ? model.class_name : model.name)
        rescue => e
          failed << {
            model: (model.respond_to?(:class_name) ? model.class_name : model.name),
            error: e.message
          }
        end
      end

      { success: worked, failure: failed, data: data }
    end

    def get_scopes_for_model(model)
      return nil unless model.respond_to?(:defined_scopes)

      result = {}
      all_sql = model.all.to_sql
      model.defined_scopes.each do |name, block|
        begin

          # for each scope, check the arity. don't handle params for now
          if block.respond_to?(:arity) && block.arity != 0
            puts "skipped #{name} because arity was #{block.arity}"
            next
          end

          scope_sql = model.send(name).to_sql

          # return scopes that have a where or order only... skip joins for now
          if !scope_sql.include?(all_sql)
            puts "skipped #{name} because sql wasn't included"
            next
          end

          new_sql = scope_sql.gsub(all_sql, "")&.strip
          result[name] = new_sql
        rescue => e
          Rails.logger.warn "Failed processing scope #{name} on #{model.name}: #{e.message}"
        end
      end

      result
    end

    def require_page!
      if params[:page].blank?
        render json: "You must specify a page param", status: 422
        return
      end
    end

  end
end
