module Utxoracle
  class Provider
    def init
      raise NoMethodError
    end

    def getblockcount
      raise NoMethodError
    end

    def getblockhash
      raise NoMethodError
    end

    def getblockheader
      raise NoMethodError
    end

    def getblock
      raise NoMethodError
    end

    # TODO - Build a mechanism allowing for fallbacks; be fault tolerant to node, website, etc.
  end
end
