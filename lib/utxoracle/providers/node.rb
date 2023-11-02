require_relative '../provider'
require_relative '../rpc'

module Utxoracle
  class Node < Provider
    def initialize(rpcuser, rpcpassword, ip, port)
      @rpc = Rpc.new("http://#{rpcuser}:#{rpcpassword}@#{ip}:#{port}")
    end

    def getblockcount
      @rpc.getblockcount
    end

    def getblockhash(height)
      @rpc.getblockhash(height)
    end

    def getblockheader(block_hash, verbose = true)
      @rpc.getblockheader(block_hash, verbose)
    end

    def getblock(block_hash, verbosity = 2)
      @rpc.getblock(block_hash, verbosity)
    end
  end
end
