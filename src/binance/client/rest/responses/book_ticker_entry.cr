module Binance::Responses
  # Typical Server Response:
  #     {
  #       "symbol": "LTCBTC",
  #       "bidPrice": "4.00000000",
  #       "bidQty": "431.00000000",
  #       "askPrice": "4.00000200",
  #       "askQty": "9.00000000"
  #     }
  #
  class BookTickerEntry
    include JSON::Serializable

    @[JSON::Field(key: "symbol")]
    getter symbol : String = ""

    @[JSON::Field(key: "bidPrice", converter: Binance::Converters::ToFloat)]
    getter bid_price : Float64 = 0.0

    @[JSON::Field(key: "bidQty", converter: Binance::Converters::ToFloat)]
    getter bid_quantity : Float64 = 0.0

    @[JSON::Field(key: "askPrice", converter: Binance::Converters::ToFloat)]
    getter ask_price : Float64 = 0.0

    @[JSON::Field(key: "askQty", converter: Binance::Converters::ToFloat)]
    getter ask_quantity : Float64 = 0.0
  end
end
