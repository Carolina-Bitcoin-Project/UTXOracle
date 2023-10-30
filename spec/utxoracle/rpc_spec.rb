# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Utxoracle::Rpc do
  let(:rpc) do
    described_class.new('http://foo:bar@127.0.0.1:8332')
  end
  describe '.new' do
    it 'creates an instance of Rpc with given uri' do
      expect(rpc.class).to eq(Utxoracle::Rpc)
    end
  end

  it 'exposes http request interface' do
    allow(rpc).to receive(:http_post_request).and_return(true)
    expect(rpc.http_post_request("")).to eq true
  end

  it 'forwards methods over http' do
    allow(rpc).to receive(:http_post_request).and_return("{\"result\":814521,\"error\":null,\"id\":\"jsonrpc\"}\n")
    expect(rpc.getblockcount).to eq 814521
  end

  it 'returns error from http endpoint when indicated' do
    expect(rpc).to receive(:http_post_request).and_return("{\"result\":814521,\"error\":\"test error\",\"id\":\"jsonrpc\"}\n")
    expect{ rpc.test_rpc_call }.to raise_error(Utxoracle::Rpc::JSONRPCError)
  end
end
