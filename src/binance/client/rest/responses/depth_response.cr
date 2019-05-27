module Binance::Responses

  # Typical Server Response:
  #     {
  #       "lastUpdateId": 1027024,
  #       "bids": [
  #         [
  #           "4.00000000",     // PRICE
  #           "431.00000000"    // QTY
  #         ]
  #       ],
  #       "asks": [
  #         [
  #           "4.00000200",
  #           "12.00000000"
  #         ]
  #       ]
  #     }
  class DepthResponse < ServerResponse
    @[JSON::Field(key: "lastUpdateId")]
    getter last_update_id : Int32 = 0

    @[JSON::Field(key: "bids", converter: Binance::Converters::ToDepthEntry)]
    getter bids : Array(Binance::Responses::DepthEntry) = [] of Binance::Responses::DepthEntry

    @[JSON::Field(key: "asks", converter: Binance::Converters::ToDepthEntry)]
    getter asks : Array(Binance::Responses::DepthEntry) = [] of Binance::Responses::DepthEntry
  end
end