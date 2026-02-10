# frozen_string_literal: true

require_relative "lib/auto_api/version"

Gem::Specification.new do |spec|
  spec.name = "auto-api-client"
  spec.version = AutoApi::VERSION
  spec.authors = ["AUTO-API.COM"]
  spec.email = ["support@auto-api.com"]

  spec.summary = "Ruby client for auto-api.com"
  spec.description = "Ruby client for auto-api.com — car listings API across multiple marketplaces."
  spec.homepage = "https://github.com/autoapicom/auto-api-ruby"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/autoapicom/auto-api-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/autoapicom/auto-api-ruby/blob/main/CHANGELOG.md"
  spec.metadata["keywords"] = "encar api, mobile.de api, autoscout24 api, che168 api, dongchedi api, guazi api, dubicars api, dubizzle api"

  spec.files = Dir["lib/**/*.rb", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]
end
