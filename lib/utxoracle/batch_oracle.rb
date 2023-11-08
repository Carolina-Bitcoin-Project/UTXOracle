# frozen_string_literal: true

module Utxoracle
  class BatchOracle
    def initialize(provider, log = false)
      @provider   = provider
      @log        = log
    end

    def prices(start_date, end_date)
      formatted_start_date  = Time.parse start_date.tr('\n', '')
      formatted_end_date    = Time.parse end_date.tr('\n', '')
      ret                   = {}

      date = formatted_start_date
      threads = []

      while date < formatted_end_date
        # Bind `date` to thread scope: https://ruby-doc.org/core-2.0.0/Thread.html#method-c-new
        threads << Thread.new(date) do |t_date|
          oracle = Utxoracle::Oracle.new(@provider, log = @log)
          date_str = t_date.to_s[0..9]
          ret[date_str] = oracle.price(date_str)
        end

        date += Utxoracle::Oracle::SECONDS_PER_DAY
      end
      threads.each(&:join)

      puts ret
      ret
    end
  end
end
