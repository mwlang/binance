# {
#   "u":400900217,     // order book updateId
#   "s":"BNBUSDT",     // symbol
#   "b":"25.35190000", // best bid price
#   "B":"31.21000000", // best bid qty
#   "a":"25.36520000", // best ask price
#   "A":"40.66000000"  // best ask qty
# }
module Binance::Responses::Websocket
  class BookTicker < Data
    include JSON::Serializable

    @[JSON::Field(key: "b", converter: Binance::Converters::ToFloat)]
    getter bid_price : Float64 = 0.0

    @[JSON::Field(key: "B", converter: Binance::Converters::ToFloat)]
    getter bid_quantity : Float64 = 0.0

    @[JSON::Field(key: "a", converter: Binance::Converters::ToFloat)]
    getter ask_price : Float64 = 0.0

    @[JSON::Field(key: "A", converter: Binance::Converters::ToFloat)]
    getter ask_quantity : Float64 = 0.0
  end
end
