Lazer::Engine.routes.draw do
  resource :schema, controller: :schema
  resource :scopes, controller: :scopes
end
