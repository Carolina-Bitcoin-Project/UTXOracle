# frozen_string_literal: true

require_relative 'lib/utxoracle/version'

Gem::Specification.new do |spec|
  spec.name = 'UTXOracle'
  spec.version = UTXOracle::VERSION
  spec.authors = ['Keith Gardner']

  spec.summary = 'Object oriented interface for UTXOracle'
  spec.description = 'Object oriented interface for UTXOracle'
  spec.homepage = 'https://github.com/Carolina-Bitcoin-Project/UTXOracle'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.add_development_dependency 'rubocop'
end
