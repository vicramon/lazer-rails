# Lazer

Tiny rails engine to provide your schema to Lazer.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'lazer'
```

```bash
bundle
```

Mount the engine:

```
# config/routes.rb
mount Lazer::Engine => "/lazer"
```

This exposes the `/lazer/schema?lazer_key=API_KEY` endpoint.

The Lazer app will hit this endpoint periodically to keep your schema up to date. The default schedule is daily, but this is configurable in Lazer.

Don't forget to setup your api key in the Lazer app, then set your env variable to your api key:

```
LAZER_KEY=YOUR_API_KEY
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
