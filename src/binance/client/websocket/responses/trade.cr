# {
#   "e": "trade",     // Event type
#   "E": 123456789,   // Event time
#   "s": "BNBBTC",    // Symbol
#   "t": 12345,       // Trade ID
#   "p": "0.001",     // Price
#   "q": "100",       // Quantity
#   "b": 88,          // Buyer order ID
#   "a": 50,          // Seller order ID
#   "T": 123456785,   // Trade time
#   "m": true,        // Is the buyer the market maker?
#   "M": true         // Ignore
# }
module Binance::Responses::Websocket
  class Trade < Data
    include JSON::Serializable

    @[JSON::Field(key: "t")]
    getter trade_id : Int64

    @[JSON::Field(key: "p", converter: Binance::Converters::ToFloat)]
    getter price : Float64

    @[JSON::Field(key: "q", converter: Binance::Converters::ToFloat)]
    getter quote_quantity : Float64

    @[JSON::Field(key: "b")]
    getter buyer_order_id : Int64 = 0

    @[JSON::Field(key: "a")]
    getter seller_order_id : Int64 = 0

    @[JSON::Field(key: "T", converter: Binance::Converters::ToTime)]
    getter trade_time : Time = Time.utc

    @[JSON::Field(key: "m")]
    getter is_buyer_maker : Bool

    @[JSON::Field(key: "M")]
    getter ignore : Bool
  end
end
