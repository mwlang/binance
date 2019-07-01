module Binance::Responses
  # Typical Server Response:
  #     {
  #       "asset": "LTC",
  #       "free": "4763368.68006011",
  #       "locked": "0.00000000"
  #     }
  #
  class BalanceEntry
    include JSON::Serializable

    @[JSON::Field(key: "asset")]
    getter asset : String = ""

    @[JSON::Field(key: "free", converter: Binance::Converters::ToFloat)]
    getter free : Float64 = 0.0

    @[JSON::Field(key: "locked", converter: Binance::Converters::ToFloat)]
    getter locked : Float64 = 0.0
  end
end
