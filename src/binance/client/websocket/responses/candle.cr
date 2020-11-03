# {
#   "e": "kline",     // Event type
#   "E": 123456789,   // Event time
#   "s": "BNBBTC",    // Symbol
#   "k": {
#     "t": 123400000, // Kline start time
#     "T": 123460000, // Kline close time
#     "s": "BNBBTC",  // Symbol
#     "i": "1m",      // Interval
#     "f": 100,       // First trade ID
#     "L": 200,       // Last trade ID
#     "o": "0.0010",  // Open price
#     "c": "0.0020",  // Close price
#     "h": "0.0025",  // High price
#     "l": "0.0015",  // Low price
#     "v": "1000",    // Base asset volume
#     "n": 100,       // Number of trades
#     "x": false,     // Is this kline closed?
#     "q": "1.0000",  // Quote asset volume
#     "V": "500",     // Taker buy base asset volume
#     "Q": "0.500",   // Taker buy quote asset volume
#     "B": "123456"   // Ignore
#   }
# }
module Binance::Responses::Websocket
  class Candle
    include JSON::Serializable

    @[JSON::Field(key: "t", converter: Binance::Converters::ToTime)]
    getter open_time : Time
    @[JSON::Field(key: "T", converter: Binance::Converters::ToTime)]
    getter close_time : Time

    @[JSON::Field(key: "i")]
    getter interval : String = ""

    @[JSON::Field(key: "n")]
    getter trades : Int64 = 0
    @[JSON::Field(key: "f")]
    getter first_trade_id : Int64 = 0
    @[JSON::Field(key: "L")]
    getter last_trade_id : Int64 = 0

    @[JSON::Field(key: "s")]
    getter symbol : String = ""
    @[JSON::Field(key: "x")]
    getter closed : Bool = false

    @[JSON::Field(key: "o", converter: Binance::Converters::ToFloat)]
    getter open_price : Float64
    @[JSON::Field(key: "h", converter: Binance::Converters::ToFloat)]
    getter high_price : Float64
    @[JSON::Field(key: "l", converter: Binance::Converters::ToFloat)]
    getter low_price : Float64
    @[JSON::Field(key: "c", converter: Binance::Converters::ToFloat)]
    getter close_price : Float64

    @[JSON::Field(key: "v", converter: Binance::Converters::ToFloat)]
    getter base_volume : Float64
    @[JSON::Field(key: "q", converter: Binance::Converters::ToFloat)]
    getter quote_volume : Float64

    @[JSON::Field(key: "V", converter: Binance::Converters::ToFloat)]
    getter taker_base_volume : Float64
    @[JSON::Field(key: "Q", converter: Binance::Converters::ToFloat)]
    getter taker_quote_volume : Float64

    @[JSON::Field(key: "B")]
    getter reserved : String
  end
end
