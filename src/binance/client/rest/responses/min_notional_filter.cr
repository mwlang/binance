module Binance::Responses
  # Typical Server Response:
  #     {
  #       "filterType":"MIN_NOTIONAL",
  #       "minNotional":"0.00100000",
  #       "applyToMarket":true,
  #       "avgPriceMins":5
  #     }
  #
  # The MIN_NOTIONAL filter defines the minimum notional value allowed for an order on a symbol.
  # An order's notional value is the price * quantity. applyToMarket determines whether or not
  # the MIN_NOTIONAL filter will also be applied to MARKET orders. Since MARKET orders have no price,
  # the average price is used over the last avgPriceMins minutes. avgPriceMins is the number of minutes
  # the average price is calculated over. 0 means the last price is used.
  #
  class MinNotionalFilter < ExchangeFilter
    @[JSON::Field(key: "minNotional", converter: Binance::Converters::ToFloat)]
    getter min_notional : Float64 = 0.0

    @[JSON::Field(key: "applyToMarket")]
    getter apply_to_market : Bool = true

    @[JSON::Field(key: "avgPriceMins")]
    getter avg_price_mins : Int32 = 0

    def valid?(value : Float64)
      raise FilterException.new("not implemented")
    end
  end
end
