module Lazer
  class ScopesController < ApplicationController

    def show
      render json: try_all_models.to_json
    end

    def try_all_models
      Rails.application.eager_load!
      models = ActiveRecord::Base.descendants
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

  end
end
