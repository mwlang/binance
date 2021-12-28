# {
#   "e": "24hrTicker",  // Event type
#   "E": 123456789,     // Event time
#   "s": "BNBBTC",      // Symbol
#   "p": "0.0015",      // Price change
#   "P": "250.00",      // Price change percent
#   "w": "0.0018",      // Weighted average price
#   "x": "0.0009",      // First trade(F)-1 price (first trade before the 24hr rolling window)
#   "c": "0.0025",      // Last price
#   "Q": "10",          // Last quantity
#   "b": "0.0024",      // Best bid price
#   "B": "10",          // Best bid quantity
#   "a": "0.0026",      // Best ask price
#   "A": "100",         // Best ask quantity
#   "o": "0.0010",      // Open price
#   "h": "0.0025",      // High price
#   "l": "0.0010",      // Low price
#   "v": "10000",       // Total traded base asset volume
#   "q": "18",          // Total traded quote asset volume
#   "O": 0,             // Statistics open time
#   "C": 86400000,      // Statistics close time
#   "F": 0,             // First trade ID
#   "L": 18150,         // Last trade Id
#   "n": 18151          // Total number of trades
# }
module Binance::Responses::Websocket
  class Ticker < MiniTicker
    include JSON::Serializable

    @[JSON::Field(key: "p", converter: Binance::Converters::ToFloat)]
    getter price_change : Float64 = 0.0

    @[JSON::Field(key: "P", converter: Binance::Converters::ToFloat)]
    getter price_change_percent : Float64 = 0.0

    @[JSON::Field(key: "w", converter: Binance::Converters::ToFloat)]
    getter weighted_average_price : Float64 = 0.0

    @[JSON::Field(key: "x", converter: Binance::Converters::ToFloat)]
    getter prev_close_price : Float64 = 0.0

    @[JSON::Field(key: "Q", converter: Binance::Converters::ToFloat)]
    getter last_quantity : Float64 = 0.0

    @[JSON::Field(key: "b", converter: Binance::Converters::ToFloat)]
    getter bid_price : Float64 = 0.0

    @[JSON::Field(key: "B", converter: Binance::Converters::ToFloat)]
    getter bid_quantity : Float64 = 0.0

    @[JSON::Field(key: "a", converter: Binance::Converters::ToFloat)]
    getter ask_price : Float64 = 0.0

    @[JSON::Field(key: "A", converter: Binance::Converters::ToFloat)]
    getter ask_quantity : Float64 = 0.0

    @[JSON::Field(key: "O", converter: Binance::Converters::ToTime)]
    getter open_time : Time?

    @[JSON::Field(key: "C", converter: Binance::Converters::ToTime)]
    getter close_time : Time?

    @[JSON::Field(key: "F")]
    getter first_trade_id : Int64 = 0

    @[JSON::Field(key: "L")]
    getter last_trade_id : Int64 = 0

    @[JSON::Field(key: "n")]
    getter trades : Int64 = 0

    def self.from_data(data : Data)
      from_json(data.json_unmapped.to_json).tap do |ticker|
        ticker.symbol = data.symbol
      end
    end

    def open_time
      @event_time - 24.hours - 1.second
    end

    def close_time
      @event_time
    end
  end
end
