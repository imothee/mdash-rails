require_relative "lib/mdash/version"

Gem::Specification.new do |spec|
  spec.name        = "mdash"
  spec.version     = Mdash::VERSION
  spec.authors     = [ "Tim Marks" ]
  spec.email       = [ "t@imothee.com" ]
  spec.homepage    = "https://mdash.app"
  spec.summary     = "mdash-rails exposes metrics for your Rails app to be consumed by the mdash app."
  spec.description = "mdash-rails exposes metrics for your Rails app to be consumed by the mdash app."
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/imothee/mdash-rails"
  spec.metadata["changelog_uri"] = "https://github.com/imothee/mdash-rails/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.1"
  spec.add_dependency "groupdate", "~> 6.5"
end
