# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$:.unshift lib unless $:.include?(lib)

require 'utxoracle/version'

Gem::Specification.new do |spec|
  spec.name                   = 'utxoracle'
  spec.version                = Utxoracle::VERSION
  spec.platform               = Gem::Platform::RUBY
  spec.authors                = ['Keith Gardner']

  spec.summary                = 'Interface for UTXOracle.'
  spec.description            = 'Object oriented design for interacting with UTXOracle.'
  spec.homepage               = 'https://github.com/Carolina-Bitcoin-Project/UTXOracle'
  spec.license                = 'MIT'
  spec.required_ruby_version  = '>= 3.1.0'

  spec.files                  = `git ls-files`.split("\n")
  spec.bindir                 = 'exe'
  spec.require_path           = 'lib'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-console'
end
