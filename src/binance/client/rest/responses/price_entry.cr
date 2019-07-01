module Binance::Responses
  # Typical Server Response:
  #     {
  #       "symbol": "LTCBTC",
  #       "price": "4.00000200"
  #     }
  #
  class PriceEntry
    include JSON::Serializable

    @[JSON::Field(key: "symbol")]
    getter symbol : String = ""

    @[JSON::Field(key: "price", converter: Binance::Converters::ToFloat)]
    getter price : Float64 = 0.0
  end
end
