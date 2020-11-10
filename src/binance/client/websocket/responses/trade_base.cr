# {
#   "e": "trade",     // Event type
#   "E": 123456789,   // Event time
#   "s": "BNBBTC",    // Symbol
#   "p": "0.001",     // Price
#   "q": "100",       // Quantity
#   "T": 123456785,   // Trade time
#   "m": true,        // Is the buyer the market maker?
#   "M": true         // Ignore
# }
module Binance::Responses::Websocket
  class TradeBase < Data
    @[JSON::Field(key: "p", converter: Binance::Converters::ToFloat)]
    getter price : Float64

    @[JSON::Field(key: "q", converter: Binance::Converters::ToFloat)]
    getter quote_quantity : Float64

    @[JSON::Field(key: "T", converter: Binance::Converters::ToTime)]
    getter trade_time : Time = Time.utc

    @[JSON::Field(key: "m")]
    getter is_buyer_maker : Bool

    @[JSON::Field(key: "M")]
    getter ignore : Bool
  end
end
