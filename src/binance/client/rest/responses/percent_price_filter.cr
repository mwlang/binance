module Binance::Responses
  class PercentPriceFilter < ExchangeFilter
    @[JSON::Field(key: "multiplierUp", converter: Binance::Converters::ToFloat)]
    getter multiplier_up : Float64 = 0.0

    @[JSON::Field(key: "multiplierDown", converter: Binance::Converters::ToFloat)]
    getter multiplier_down : Float64 = 0.0

    @[JSON::Field(key: "avgPriceMins")]
    getter avg_price_mins : Int32 = 0
  end
end
