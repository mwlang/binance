module Binance::Responses
  # Typical server response
  #     {
  #       "filterType":"LOT_SIZE",
  #       "minQty":"0.00100000",
  #       "maxQty":"100000.00000000",
  #       "stepSize":"0.00100000"
  #     }
  class LotSizeFilter < ExchangeFilter
    @[JSON::Field(key: "minQty", converter: Binance::Converters::ToFloat)]
    getter min_quantity : Float64 = 0.0

    @[JSON::Field(key: "maxQty", converter: Binance::Converters::ToFloat)]
    getter max_quantity : Float64 = 0.0

    @[JSON::Field(key: "stepSize", converter: Binance::Converters::ToFloat)]
    getter step_size : Float64 = 0.0
  end
end
