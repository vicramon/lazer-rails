require_dependency "lazer/application_controller"

module Lazer
  class ScopesController < ApplicationController

    def show
      render json: try_all_models
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
            data[model.name] ||= {}
            data[model.name][:scopes] = scopes
            data[model.name][:table_name] = model.table_name
          end
          worked << model.class_name
        rescue => e
          failed << [model.class_name, e.message]
        end
      end
      return { worked: worked, failed: failed, data: data }
    end

    def get_scopes_for_model(model)
      result = {}
      scopes = model.instance_variable_get(:@__scopes__)
      all_sql = model.all.to_sql
      return nil if scopes.blank?
      scopes.each do |scope|
        name = scope[0]
        block = scope[1]
        # for each scope, check the arity. don't handle params for now
        if block.arity != 0
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
      end
      return result
    end

  end
end
