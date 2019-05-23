module Binance::Responses
  # Typical server response
  #     {
  #       "filterType":"PRICE_FILTER",
  #       "minPrice":"0.00000100",
  #       "maxPrice":"100000.00000000",
  #       "tickSize":"0.00000100"
  #     }
  class PriceFilter < ExchangeFilter
    @[JSON::Field(key: "minPrice", converter: Binance::Converters::ToFloat)]
    getter min_price : Float64 = 0.0

    @[JSON::Field(key: "maxPrice", converter: Binance::Converters::ToFloat)]
    getter max_price : Float64 = 0.0

    @[JSON::Field(key: "tickSize", converter: Binance::Converters::ToFloat)]
    getter tick_size : Float64 = 0.0
  end
end
