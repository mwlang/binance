module Binance::Responses
  # Typical server response
  #     {
  #       "filterType":"PRICE_FILTER",
  #       "minPrice":"0.00000100",
  #       "maxPrice":"100000.00000000",
  #       "tickSize":"0.00000100"
  #     }
  class DepthEntry
    getter price : Float64 = 0.0
    getter quantity : Float64 = 0.0

    def initialize(pull : JSON::PullParser)
      pull.read_begin_array
      @price = pull.read_string.to_f
      @quantity = pull.read_string.to_f
      pull.read_end_array
    end
  end
end
