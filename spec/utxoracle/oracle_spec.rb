# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Utxoracle::Oracle do
  describe '.new' do
    it 'requires provider and takes optional log config' do
      provider = Utxoracle::Mempool
      Utxoracle::Oracle.new(provider, log = true)
    end
  end

  describe 'date validation' do
    it 'returns -1 for garbage date inputs' do
      provider = Utxoracle::Mempool
      oracle = Utxoracle::Oracle.new(provider)
      price = oracle.price('garbage')
      expect(price).to be(-1)
    end

    it 'returns -1 for dates before 2020-07-26' do
      provider = Utxoracle::Mempool
      oracle = Utxoracle::Oracle.new(provider)
      price = oracle.price('2015-01-01')
      expect(price).to be(-1)
    end

    it 'returns -1 for dates in the future' do
      provider = Utxoracle::Mempool
      oracle = Utxoracle::Oracle.new(provider)
      price = oracle.price('3000-01-01')
      expect(price).to be(-1)
    end
  end

  # TODO: - test cache
  # TODO - test provider interface
  # TODO - test `price` return type
end
