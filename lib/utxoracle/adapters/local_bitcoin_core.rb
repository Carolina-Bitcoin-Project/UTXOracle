require '../adapter'

module Utxoracle
  # Wrapper for hitting raw node on given IP/PORT.
  class LocalBitcoinCore < Adapter
    def init; end

    def getblockcount; end

    def getblockhash; end

    def getblockheader; end

    def getblock; end
  end
end
