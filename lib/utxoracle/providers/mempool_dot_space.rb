require_relative '../provider'
require_relative '../request'

# Unfortunately Mempool limits the number of tx's you can fetch in bulk,
# and throttles the number of requests the oracle takes to compute.
# Running this requires an Enterprise license.
module Utxoracle
  class MempoolDotSpace < Provider
    def initialize; end

    def getblockcount
      Request.send('https://mempool.space/api/blocks/tip/height').body.to_i
    end

    def getblockhash(height)
      Request.send("https://mempool.space/api/block-height/#{height}").body
    end

    # Oracle.price needs blockheader['time']
    def getblockheader(block_hash, _verbose = true)
      hex_block_header = Request.send("https://mempool.space/api/block/#{block_hash}/header").body

      # version = hex_to_int(reverse_byte_order(hex_block_header[0..7]))
      # prev_block_hash = reverse_byte_order(hex_block_header[8..71])
      # merkle_root = reverse_byte_order(hex_block_header[72..135])
      timestamp = hex_to_int(reverse_byte_order(hex_block_header[136..143]))
      # bits = reverse_byte_order(hex_block_header[144..151])
      # nonce = hex_to_int(reverse_byte_order(hex_block_header[152..159]))

      {
        'time' => timestamp
      }
    end

    def getblock(block_hash, _verbosity = 2)
      block = JSON.parse Request.send("https://mempool.space/api/block/#{block_hash}").body

      # mempool API maps 'timestamp' to 'time'
      block['time'] = block['timestamp']

      # mempool API doesn't return tx. Set to empty array:
      block['tx'] = []

      # Get all tx_ids in the block
      tx_ids = JSON.parse Request.send("https://mempool.space/api/block/#{block_hash}/txids").body

      # Append vout to block['tx']
      # ( requires mempool enterprise: 429 Too Many Requests)
      tx_ids.each do |tx_id|
        tx = JSON.parse Request.send("https://mempool.space/api/tx/#{tx_id}").body
        block['tx'] << tx['vout']
      end

      block
    end

    private

    # Reverse byte order in a hexadecimal string.
    def reverse_byte_order(hex_string)
      hex_string.scan(/../).reverse.join
    end

    # Convert hexadecimal string to an integer.
    def hex_to_int(hex_string)
      hex_string.to_i(16)
    end
  end
end
