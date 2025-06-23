# Lazer Ruby Gem

This gem provides a Rails engine that allows Lazer to import your apps scopes and Active Record relationships.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'lazer-rails'
```

Bundle, and restart your server.

```bash
bundle
```

Mount the engine:

```
# config/routes.rb
mount Lazer::Engine => "/lazer-gem-api"
```

Add a new codebase in Lazer to get an API key, then set it as an environment variable:

```
LAZER_KEY=YOUR_API_KEY
```

## How it works

This gem adds two endpoints to your app, one for scopes and one for relationships. It uses the API key for authentication.

The Lazer app will hit these endpoints periodically so that your Lazer instance stays up to date.
