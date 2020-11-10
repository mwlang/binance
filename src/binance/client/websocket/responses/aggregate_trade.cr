# {
#   "e": "aggTrade",  // Event type
#   "E": 123456789,   // Event time
#   "s": "BNBBTC",    // Symbol
#   "a": 12345,       // Aggregate trade ID
#   "p": "0.001",     // Price
#   "q": "100",       // Quantity
#   "f": 100,         // First trade ID
#   "l": 105,         // Last trade ID
#   "T": 123456785,   // Trade time
#   "m": true,        // Is the buyer the market maker?
#   "M": true         // Ignore
# }
#
# Base DIFF:
#
# {
#   "a": 12345,       // Aggregate trade ID
#   "f": 100,         // First trade ID
#   "l": 105,         // Last trade ID
# }
#
module Binance::Responses::Websocket
  class AggregateTrade < TradeBase
    @[JSON::Field(key: "a")]
    getter trade_id : Int64 = 0

    @[JSON::Field(key: "f")]
    getter first_trade_id : Int64 = 0

    @[JSON::Field(key: "l")]
    getter last_trade_id : Int64 = 0
  end
end
