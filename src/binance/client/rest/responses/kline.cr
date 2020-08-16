# This is the overview commentary
module Binance::Responses
  # Kline/candlestick bars for a symbol. Klines are uniquely identified by their open time.
  #
  # Weight: 1
  #
  # Parameters:
  #
  # <table>
  # <thead>
  # <tr> <th>Name</th> <th>Type</th> <th>Mandatory</th> <th>Description</th> </tr>
  # </thead>
  # <tbody>
  # <tr> <td>symbol</td> <td>STRING</td> <td>YES</td> <td></td> </tr>
  # <tr> <td>interval</td> <td>ENUM</td> <td>YES</td> <td></td> </tr>
  # <tr> <td>startTime</td> <td>LONG</td> <td>NO</td> <td></td> </tr>
  # <tr> <td>endTime</td> <td>LONG</td> <td>NO</td> <td></td> </tr>
  # <tr> <td>limit</td> <td>INT</td> <td>NO</td> <td>Default 500; max 1000.</td> </tr>
  # </tbody>
  # </table>
  #
  # * If startTime and endTime are not sent, the most recent klines are returned.
  #
  # ## Example Usage
  #
  # ```crystal
  # response = client.klines("BNBUSDT", "1h", 5)
  # response.klines.size               # => 5
  # response.klines.map(&.open_price)  # => [34.4949, 34.3671, 34.3842, 34.2751, 34.2592]
  # response.klines.map(&.close_price) # => [34.3887, 34.376, 34.2218, 34.2658, 34.2749]
  # response.klines[0].open_time       # => "2019-06-28 17:00:00 UTC"
  # response.klines[0].close_time      # => "2019-06-28 17:59:59 UTC"
  # response.klines[4].open_time       # => "2019-06-28 21:00:00 UTC"
  # response.klines[4].close_time      # => "2019-06-28 21:59:59 UTC"
  # ```
  #
  # ## Typical server response (unparsed JSON)
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
  #
  class Kline
    # Open Time in UTC
    getter open_time : Time

    # Open Price
    getter open_price : Float64

    # High Price
    getter high_price : Float64

    # Low Price
    getter low_price : Float64

    # Close Price (this can fluxuate for still open candles!)
    getter close_price : Float64

    # Close Time in UTC
    getter close_time : Time

    # Volume expressed in the base asset
    getter base_volume : Float64

    # Volume expressed in the target (quote) asset
    getter quote_volume : Float64

    # Number of trades on asset pair in interval
    getter trades : Int32

    # Volume of taker trades on base asset
    getter taker_base_volume : Float64

    # Volume of taker trades expressed in the target (quote) asset
    getter taker_quote_volume : Float64

    # Unknown/undocumented
    getter reserved : Float64

    # :nodoc:
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
