module Binance::Responses
  # Typical server response
  #   {
  #     "id": 52027722,
  #     "price": "0.00324060",
  #     "qty": "3.27000000",
  #     "quoteQty": "0.01059676",
  #     "time": 1561473127043,
  #     "isBuyerMaker": false,
  #     "isBestMatch": true
  #   }
  class TradeEntry
    include JSON::Serializable

    @[JSON::Field(key: "id")]
    getter trade_id : Int64

    @[JSON::Field(key: "price", converter: Binance::Converters::ToFloat)]
    getter price : Float64

    @[JSON::Field(key: "qty", converter: Binance::Converters::ToFloat)]
    getter quantity : Float64

    @[JSON::Field(key: "quoteQty", converter: Binance::Converters::ToFloat)]
    getter quote_quantity : Float64

    @[JSON::Field(key: "time", converter: Binance::Converters::ToTime)]
    getter time : ::Time = ::Time.utc

    @[JSON::Field(key: "isBuyerMaker")]
    getter is_buyer_maker : Bool

    @[JSON::Field(key: "isBestMatch")]
    getter is_best_match : Bool
  end
end
