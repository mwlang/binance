module Binance::Responses
  # Typical Server Response:
  #     {
  #       "price": "4000.00000000",
  #       "qty": "1.00000000",
  #       "commission": "4.00000000",
  #       "commissionAsset": "USDT"
  #     }
  class OrderFill
    include JSON::Serializable

    @[JSON::Field(key: "price", converter: Binance::Converters::ToFloat)]
    getter price : Float64 = 0.0

    @[JSON::Field(key: "qty", converter: Binance::Converters::ToFloat)]
    getter quantity : Float64 = 0.0

    @[JSON::Field(key: "commission", converter: Binance::Converters::ToFloat)]
    getter commission : Float64 = 0.0

    @[JSON::Field(key: "commissionAsset")]
    getter commission_asset : String = ""
  end
end
