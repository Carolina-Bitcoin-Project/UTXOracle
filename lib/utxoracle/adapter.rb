# TODO: - Interface for adapters to a bitcoin core RPC

module Utxoracle
  class Adapter
    def init
      raise NoMethodError
    end

    # TODO: - Define OTF
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
  end
end
