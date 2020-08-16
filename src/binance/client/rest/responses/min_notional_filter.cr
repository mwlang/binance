module Binance::Responses
  # Typical Server Response:
  #     {
  #       "filterType":"MIN_NOTIONAL",
  #       "minNotional":"0.00100000",
  #       "applyToMarket":true,
  #       "avgPriceMins":5
  #     }
  class MinNotionalFilter < ExchangeFilter
    @[JSON::Field(key: "minNotional", converter: Binance::Converters::ToFloat)]
    getter min_notional : Float64 = 0.0

    @[JSON::Field(key: "applyToMarket")]
    getter apply_to_market : Bool = true

    @[JSON::Field(key: "avgPriceMins")]
    getter avg_price_mins : Int32 = 0
  end
end
