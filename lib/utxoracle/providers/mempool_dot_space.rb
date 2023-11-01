require_relative '../provider'

module Utxoracle
  class MempoolDotSpace < Provider
    def initialize; end

    def getblockcount; end

    def getblockhash(height); end

    def getblockheader(block_hash, verbose = true); end

    def getblock(block_hash, verbosity = 2); end
  end
end
