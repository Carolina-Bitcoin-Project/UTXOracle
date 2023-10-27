require 'time'
require './bitcoin_rpc.rb'
require 'pry' # REMOVE

class UTXOracle

  SECONDS_IN_A_DAY = 60*60*24.freeze
  FOUR_HOURS = 14400.freeze

  MAINNET_PORT = 8332.freeze
  TESTNET_PORT = 18332.freeze

  NUMBER_OF_BINS = 2401.freeze

  # opts: testnet or main net, user, password, port.
  def initialize(log=false)
    # TODO - params username, password, IP, port
    @client = BitcoinRPC.new('http://foo:bar@127.0.0.1:8332')
    @round_usd_stencil = build_round_usd_stencil # TODO - reuse

    @log = log
  end

  def price(requested_date)
    puts "Ruby UTXOracle version 1\n\n" if @log

    # TODO - move this to validation block, print as bounds error
    #puts "Earliest available price: 7-26-20"
    #puts "Latest available price: #{latest_price_date}"
    #puts "Enter the date to request (YYYY-MM-DD): "



    @requested_date = Time.parse requested_date.tr('\n', '')
    run

    # TODO - since historical UTXO set is static, cache prices for given date
  end

  private

  def run
    block_count     = @client.getblockcount
    block_hash      = @client.getblockhash(block_count)
    blockheader     = @client.getblockheader(block_hash, true)

    time_datetime = Time.at(blockheader["time"]).utc
    latest_year = time_datetime.year
    latest_month = time_datetime.month
    latest_day = time_datetime.day
    latest_utc_midnight = Time.new(latest_year, latest_month, latest_day).utc

    latest_time_in_seconds = blockheader['time']
    yesterday_seconds = latest_time_in_seconds - SECONDS_IN_A_DAY
    latest_price_day = Time.at(yesterday_seconds).utc
    latest_price_date = latest_price_day.utc.strftime("%Y-%m-%d")


    price_day_seconds =  @requested_date.to_i - FOUR_HOURS
    price_day_date_utc = @requested_date

    seconds_since_price_day = latest_time_in_seconds - price_day_seconds
    blocks_ago_estimate = (144 * seconds_since_price_day.to_f / SECONDS_IN_A_DAY.to_f).round
    price_day_block_estimate = (block_count - blocks_ago_estimate).to_i


    block_hash_b       = @client.getblockhash(price_day_block_estimate)
    block_header       = @client.getblockheader(block_hash_b, true)
    time_in_seconds = block_header['time']



    seconds_difference = time_in_seconds - price_day_seconds
    block_jump_estimate = (144.0*seconds_difference/SECONDS_IN_A_DAY).round

    last_estimate = 0
    last_last_estimate = 0
    while block_jump_estimate > 6 && block_jump_estimate != last_last_estimate
      last_last_estimate = last_estimate
      last_estimate = block_jump_estimate

      price_day_block_estimate = price_day_block_estimate - block_jump_estimate
      block_hash_b       = @client.getblockhash(price_day_block_estimate)
      block_header       = @client.getblockheader(block_hash_b, true)

      time_in_seconds = block_header['time']
      seconds_difference = time_in_seconds - price_day_seconds
      block_jump_estimate = (144.0*seconds_difference/SECONDS_IN_A_DAY).round
    end # Good

    if time_in_seconds > price_day_seconds
      while time_in_seconds > price_day_seconds
        price_day_block_estimate -= 1
        block_hash_b       = @client.getblockhash(price_day_block_estimate)
        block_header       = @client.getblockheader(block_hash_b, true)
        time_in_seconds = block_header['time']
      end

      # The guess is now perfectly the first block before midnight
      price_day_block_estimate = price_day_block_estimate + 1
    elsif time_in_seconds < price_day_seconds
      while time_in_seconds < price_day_seconds
        price_day_block_estimate += 1
        block_hash_b       = @client.getblockhash(price_day_block_estimate)
        block_header       = @client.getblockheader(block_hash_b, true)
        time_in_seconds = block_header['time']
      end
    end

    price_day_block = price_day_block_estimate





    # 5
    first_bin_value = -6
    last_bin_value = 6
    range_bin_values = last_bin_value - first_bin_value

    output_bell_curve_bins = [0.0]

    for exponent in -6..5
      for bin_width in 0..199
        bin_value = 10 ** (exponent + bin_width/200.0).to_f
        output_bell_curve_bins << bin_value
      end
    end

    output_bell_curve_bin_counts = []
    for n in 0..NUMBER_OF_BINS - 1
      output_bell_curve_bin_counts << 0.0
    end









    # 6
    puts ("Reading all blocks on #{price_day_date_utc}...") if @log
    puts ("This will take a few minutes (~144 blocks)...") if @log
    puts ("Height\tTime(utc)\t Completion %") if @log

    block_height = price_day_block_estimate
    block_hash_b = @client.getblockhash(block_height)
    block_b = @client.getblock(block_hash_b, 2)

    time = Time.at(block_b["time"]).utc
    time_in_seconds = block_b["time"]

    hour = time.hour
    day = time.day
    minute = time.min

    target = day
    blocks_on_this_day = 0 # Keep track of how many blocks we process

    while target == day do
      blocks_on_this_day += 1

      progress_estimate = 100.0*(hour+minute/60)/24.0
      puts ("#{block_height}\t#{time.strftime("%H:%M:%S")}\t#{progress_estimate}") if @log

      for tx in block_b["tx"]
        outputs = tx['vout']
        for output in outputs

          amount = output["value"]
          if 1e-6 < amount && amount < 1e6
            amount_log = Math::log10 amount

            percent_in_range = (amount_log - first_bin_value).to_f / range_bin_values.to_f
            bin_number_est = (percent_in_range * NUMBER_OF_BINS).to_i

            while output_bell_curve_bins[bin_number_est] <= amount
              bin_number_est += 1
            end
            bin_number = bin_number_est - 1

            output_bell_curve_bin_counts[bin_number] += 1.0
          end
        end
      end

      # get next block
      block_height += 1
      block_hash_b = @client.getblockhash(block_height)
      block_b = @client.getblock(block_hash_b, 2)

      time = Time.at(block_b["time"]).utc
      time_in_seconds = block_b["time"]
      hour = time.hour
      day = time.day
      minute = time.min
    end

    puts "blocks_on_this_day: #{blocks_on_this_day}" if @log



    # 7
    for n in 0..201 - 1
      output_bell_curve_bin_counts[n] = 0.0
    end

    for n in 1601..NUMBER_OF_BINS - 1
      output_bell_curve_bin_counts[n] = 0.0
    end

    for r in round_btc_bins
      amount_above = output_bell_curve_bin_counts[r+1]
      amount_below = output_bell_curve_bin_counts[r-1]
      output_bell_curve_bin_counts[r] = 0.5 * (amount_above+amount_below).to_f
    end

    curve_sum = 0.0
    for n in 201..1601 - 1
      curve_sum += output_bell_curve_bin_counts[n]
    end

    for n in 201..1601 - 1
      output_bell_curve_bin_counts[n] /= curve_sum
      if output_bell_curve_bin_counts[n] > 0.008
        output_bell_curve_bin_counts[n] = 0.008
      end
    end



    # 9
    best_slide       = 0
    best_slide_score = 0.0
    total_score      = 0.0
    number_of_scores = 0

    min_slide = -200
    max_slide = 200

    for slide in min_slide..max_slide - 1
      shifted_curve = output_bell_curve_bin_counts.slice(201 + slide, 1401 + slide)

      slide_score = 0.0
      for n in 0..shifted_curve.count - 1
        slide_score += shifted_curve[n] * @round_usd_stencil[n+201]
      end

      total_score += slide_score
      number_of_scores += 1

      if slide_score > best_slide_score
        best_slide_score = slide_score
        best_slide = slide
      end
    end

    usd100_in_btc_best = output_bell_curve_bins[801+best_slide]
    btc_in_usd_best = 100/(usd100_in_btc_best)

    neighbor_up = output_bell_curve_bin_counts.slice(201+best_slide+1, 1401+best_slide+1)
    neighbor_up_score = 0.0
    for n in 0..neighbor_up.count - 1
      neighbor_up_score += (neighbor_up[n]*@round_usd_stencil[n+201]).to_f
    end

    neighbor_down = output_bell_curve_bin_counts.slice(201+best_slide-1, 1401+best_slide-1)
    neighbor_down_score = 0.0
    for n in 0..neighbor_down.count - 1
      neighbor_down_score += (neighbor_down[n]*@round_usd_stencil[n+201]).to_f
    end

    best_neighbor = +1
    neighbor_score = neighbor_up_score
    if neighbor_down_score > neighbor_up_score
      best_neighbor = -1
      neighbor_score = neighbor_down_score
    end

    usd100_in_btc_2nd = output_bell_curve_bins[801+best_slide+best_neighbor]
    btc_in_usd_2nd = 100/(usd100_in_btc_2nd).to_f

    #weight average the two usd price estimates
    avg_score = total_score/number_of_scores.to_f
    a1 = best_slide_score - avg_score
    a2 = (neighbor_score - avg_score).abs  #theoretically possible to be negative
    w1 = a1/(a1+a2).to_f
    w2 = a2/(a1+a2)
    price_estimate = (w1*btc_in_usd_best + w2*btc_in_usd_2nd).to_i

    puts "price_estimate is #{price_estimate}"

  end

  def build_round_usd_stencil
    round_usd_stencil = []
    for n in 0..NUMBER_OF_BINS
      round_usd_stencil.append(0.0)
    end

    # fill the round usd stencil with the values found by the process mentioned above
    round_usd_stencil[401] = 0.0005957955691168063     # $1
    round_usd_stencil[402] = 0.0004454790662303128     # (next one for tx/atm fees)
    round_usd_stencil[429] = 0.0001763099393598914     # $1.50
    round_usd_stencil[430] = 0.0001851801497144573
    round_usd_stencil[461] = 0.0006205616481885794     # $2
    round_usd_stencil[462] = 0.0005985696860584984
    round_usd_stencil[496] = 0.0006919505728046619     # $3
    round_usd_stencil[497] = 0.0008912933078342840
    round_usd_stencil[540] = 0.0009372916238804205     # $5
    round_usd_stencil[541] = 0.0017125522985034724     # (larger needed range for fees)
    round_usd_stencil[600] = 0.0021702347223143030
    round_usd_stencil[601] = 0.0037018622326411380     # $10
    round_usd_stencil[602] = 0.0027322168706743802
    round_usd_stencil[603] = 0.0016268322583097678     # (larger needed range for fees)
    round_usd_stencil[604] = 0.0012601953416497664
    round_usd_stencil[661] = 0.0041425242880295460     # $20
    round_usd_stencil[662] = 0.0039247767475640830
    round_usd_stencil[696] = 0.0032399441632017228     # $30
    round_usd_stencil[697] = 0.0037112959007355585
    round_usd_stencil[740] = 0.0049921908828370000     # $50
    round_usd_stencil[741] = 0.0070636869018197105
    round_usd_stencil[801] = 0.0080000000000000000     # $100
    round_usd_stencil[802] = 0.0065431388282424440     # (larger needed range for fees)
    round_usd_stencil[803] = 0.0044279509203361735
    round_usd_stencil[861] = 0.0046132440551747015     # $200
    round_usd_stencil[862] = 0.0043647851395531140
    round_usd_stencil[896] = 0.0031980892880846567     # $300
    round_usd_stencil[897] = 0.0034237641632481910
    round_usd_stencil[939] = 0.0025995335505435034     # $500
    round_usd_stencil[940] = 0.0032631930982226645     # (larger needed range for fees)
    round_usd_stencil[941] = 0.0042753262790881080
    round_usd_stencil[1001] =0.0037699501474772350     # $1,000
    round_usd_stencil[1002] =0.0030872891064215764     # (larger needed range for fees)
    round_usd_stencil[1003] =0.0023237040836798163
    round_usd_stencil[1061] =0.0023671764210889895     # $2,000
    round_usd_stencil[1062] =0.0020106877104798474
    round_usd_stencil[1140] =0.0009099214128654502     # $3,000
    round_usd_stencil[1141] =0.0012008546799361498
    round_usd_stencil[1201] =0.0007862586076341524     # $10,000
    round_usd_stencil[1202] =0.0006900048077192579

    round_usd_stencil
  end

  def round_btc_bins
    [
      201,  # 1k sats
      401,  # 10k
      461,  # 20k
      496,  # 30k
      540,  # 50k
      601,  # 100k
      661,  # 200k
      696,  # 300k
      740,  # 500k
      801,  # 0.01 btc
      861,  # 0.02
      896,  # 0.03
      940,  # 0.04
      1001, # 0.1
      1061, # 0.2
      1096, # 0.3
      1140, # 0.5
      1201  # 1 btc
    ]
  end

end


oracle = UTXOracle.new

oracle.price("2023-10-10")
oracle.price("2023-10-12")
#oracle.price("2023-10-12") # can request many dates
