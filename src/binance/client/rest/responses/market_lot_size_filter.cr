module Binance::Responses
  # Typical server response
  #     {
  #       "filterType":"MARKET_LOT_SIZE",
  #       "minQty":"0.00000000",
  #       "maxQty":"63100.00000000",
  #       "stepSize":"0.00000000"
  #     }
  class MarketLotSizeFilter < ExchangeFilter
    @[JSON::Field(key: "minQty", converter: Binance::Converters::ToFloat)]
    getter min_quantity : Float64 = 0.0

    @[JSON::Field(key: "maxQty", converter: Binance::Converters::ToFloat)]
    getter max_quantity : Float64 = 0.0

    @[JSON::Field(key: "stepSize", converter: Binance::Converters::ToFloat)]
    getter step_size : Float64 = 0.0
  end
end
