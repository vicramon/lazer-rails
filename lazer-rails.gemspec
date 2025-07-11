require_relative "lib/lazer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "lazer-rails"
  spec.version     = Lazer::VERSION
  spec.authors     = ["Vic Ramon"]
  spec.email       = ["v@vicramon.com"]
  spec.require_paths = ["lib"]
  spec.homepage    = "https://www.github.com/vicramon/lazer-rails"
  spec.summary     = "Provides secure endpoints to export info for Lazer Pro"
  spec.description = "Provides secure endpoints to export info for Lazer Pro"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  end

  spec.add_dependency "railties", ">= 6.0"
  spec.add_dependency "rails", ">= 6.0"
end
