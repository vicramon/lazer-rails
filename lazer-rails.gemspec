$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "lazer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "lazer-rails"
  spec.version     = Lazer::VERSION
  spec.authors     = ["Vic Ramon"]
  spec.email       = ["v@vicramon.com"]
  spec.homepage    = "https://www.github.com/vicramon/lazer-engine"
  spec.summary     = "Provides secure endpoints to export info for Lazer Pro"
  spec.description = "Provides secure endpoints to export info for Lazer Pro"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5.0"

  spec.add_development_dependency "pg"
end
