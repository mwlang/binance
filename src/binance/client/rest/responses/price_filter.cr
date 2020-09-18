module Binance::Responses
  # ## PRICE_FILTER
  # The PRICE_FILTER defines the price rules for a symbol. There are 3 parts:
  #
  # * minPrice defines the minimum price/stopPrice allowed; disabled on minPrice == 0.
  # * maxPrice defines the maximum price/stopPrice allowed; disabled on maxPrice == 0.
  # * tickSize defines the intervals that a price/stopPrice can be increased/decreased by; disabled on tickSize == 0.
  #
  # Any of the above variables can be set to 0, which disables that rule in the price filter. In order to pass the price filter, the following must be true for price/stopPrice of the enabled rules:
  #
  #  * price >= minPrice
  #  * price <= maxPrice
  #  * (price-minPrice) % tickSize == 0
  #
  # Typical server response
  # ```json
  #     {
  #       "filterType":"PRICE_FILTER",
  #       "minPrice":"0.00000100",
  #       "maxPrice":"100000.00000000",
  #       "tickSize":"0.00000100"
  #     }
  # ```
  class PriceFilter < ExchangeFilter
    @[JSON::Field(key: "minPrice", converter: Binance::Converters::ToFloat)]
    # minPrice defines the minimum price/stopPrice allowed; disabled on minPrice == 0.
    getter min_price : Float64 = 0.0

    @[JSON::Field(key: "maxPrice", converter: Binance::Converters::ToFloat)]
    # maxPrice defines the maximum price/stopPrice allowed; disabled on maxPrice == 0.
    getter max_price : Float64 = 0.0

    @[JSON::Field(key: "tickSize", converter: Binance::Converters::ToFloat)]
    # tickSize defines the intervals that a price/stopPrice can be increased/decreased by; disabled on tickSize == 0.
    getter tick_size : Float64 = 0.00000001

    def decimals
      ((1.0 / tick_size).to_i.to_s.size - 1)
    end

    def validate(value : Float64)
      Array(String).new.tap do |errors|
        errors << "#{value} is below min_price of #{min_price}" if min_price > 0 && value <= min_price
        errors << "#{value} exceeds max_price of #{max_price}" if max_price > 0 && value >= max_price
        errors << "#{value} is an invalid tick_size #{tick_size}" if tick_size > 0 && value.round(decimals) != value
      end
    end

    def valid?(value : Float64)
      validate(value).empty?
    end
  end
end
