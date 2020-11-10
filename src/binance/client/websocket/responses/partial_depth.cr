# {
#   "lastUpdateId": 160,  // Last update ID
#   "bids": [             // Bids to be updated
#     [
#       "0.0024",         // Price level to be updated
#       "10"              // Quantity
#     ]
#   ],
#   "asks": [             // Asks to be updated
#     [
#       "0.0026",         // Price level to be updated
#       "100"            // Quantity
#     ]
#   ]
# }
module Binance::Responses::Websocket
  class PartialDepth < Data
    include JSON::Serializable

    @[JSON::Field(key: "lastUpdateId")]
    getter last_update_id : Int64 = 0

    @[JSON::Field(key: "bids", converter: Binance::Converters::ToDepthEntry)]
    getter bids : Array(Binance::Responses::DepthEntry) = [] of Binance::Responses::DepthEntry

    @[JSON::Field(key: "asks", converter: Binance::Converters::ToDepthEntry)]
    getter asks : Array(Binance::Responses::DepthEntry) = [] of Binance::Responses::DepthEntry
  end
end
