# {
#   "e": "depthUpdate", // Event type
#   "E": 123456789,     // Event time
#   "s": "BNBBTC",      // Symbol
#   "U": 157,           // First update ID in event
#   "u": 160,           // Final update ID in event
#   "b": [              // Bids to be updated
#     [
#       "0.0024",       // Price level to be updated
#       "10"            // Quantity
#     ]
#   ],
#   "a": [              // Asks to be updated
#     [
#       "0.0026",       // Price level to be updated
#       "100"           // Quantity
#     ]
#   ]
# }
module Binance::Responses::Websocket
  class Depth < Data
    include JSON::Serializable

    @[JSON::Field(key: "U")]
    getter first_update_id : Int64 = 0
    @[JSON::Field(key: "u")]
    getter last_update_id : Int64 = 0

    @[JSON::Field(key: "b", converter: Binance::Converters::ToDepthEntry)]
    getter bids : Array(Binance::Responses::DepthEntry) = [] of Binance::Responses::DepthEntry

    @[JSON::Field(key: "a", converter: Binance::Converters::ToDepthEntry)]
    getter asks : Array(Binance::Responses::DepthEntry) = [] of Binance::Responses::DepthEntry
  end
end
