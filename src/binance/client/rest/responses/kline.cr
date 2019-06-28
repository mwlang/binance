module Binance::Responses
  # Typical server response
  #     [
  #       1499040000000,      // Open time
  #       "0.01634790",       // Open
  #       "0.80000000",       // High
  #       "0.01575800",       // Low
  #       "0.01577100",       // Close
  #       "148976.11427815",  // Volume
  #       1499644799999,      // Close time
  #       "2434.19055334",    // Quote asset volume
  #       308,                // Number of trades
  #       "1756.87402397",    // Taker buy base asset volume
  #       "28.46694368",      // Taker buy quote asset volume
  #       "17928899.62484339" // Ignore.
  #     ]
  class Kline
    getter open_time : Time

    getter open_price : Float64
    getter high_price : Float64
    getter low_price : Float64
    getter close_price : Float64

    getter close_time : Time

    getter base_volume : Float64
    getter quote_volume : Float64

    getter trades : Int32

    getter taker_base_volume : Float64
    getter taker_quote_volume : Float64

    getter reserved : Float64

    def initialize(pull : JSON::PullParser)
      pull.read_begin_array
      @open_time = Binance::Converters::ToTime.from_json(pull)
      @open_price = pull.read_string.to_f
      @high_price = pull.read_string.to_f
      @low_price = pull.read_string.to_f
      @close_price = pull.read_string.to_f
      @base_volume = pull.read_string.to_f
      @close_time = Binance::Converters::ToTime.from_json(pull)
      @quote_volume = pull.read_string.to_f
      @trades = pull.read_int.to_i32
      @taker_base_volume = pull.read_string.to_f
      @taker_quote_volume = pull.read_string.to_f
      @reserved = pull.read_string.to_f
      pull.read_end_array
    end
  end
end
