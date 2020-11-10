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
#
# Base DIFF:
#
# {
#   "t": 12345,       // Trade ID
#   "b": 88,          // Buyer order ID
#   "a": 50,          // Seller order ID
# }
#
module Binance::Responses::Websocket
  class Trade < TradeBase
    @[JSON::Field(key: "t")]
    getter trade_id : Int64

    @[JSON::Field(key: "b")]
    getter buyer_order_id : Int64 = 0

    @[JSON::Field(key: "a")]
    getter seller_order_id : Int64 = 0
  end
end
