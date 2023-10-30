# frozen_string_literal: true

require 'spec_helper'

=begin
RSpec.describe Utxoracle::Oracle do
  let(:oracle) do
    described_class.new('aUser', 'aPassword', '127.0.0.1', '8332')
  end

  describe '.new' do
    it 'initialized an Rpc instance' do
      expect(Utxoracle::Rpc).to receive(:new)
      described_class.new('aUser', 'aPassword', '127.0.0.1', '8332')
      expect(oracle.class).to eq Utxoracle::Oracle
    end
  end

  # TODO: - test cache
  # TODO - test provider interface
  # TODO - test `price` return type
end
=end
