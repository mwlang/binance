module Binance::Responses
  # Typical server response
  #     [
  #         {
  #           "filterType":"PRICE_FILTER",
  #           "minPrice":"0.00000100",
  #           "maxPrice":"100000.00000000",
  #           "tickSize":"0.00000100"
  #         },
  #         {
  #           "filterType":"PERCENT_PRICE",
  #           "multiplierUp":"5",
  #           "multiplierDown":"0.2",
  #           "avgPriceMins":5
  #         },
  #         {
  #           "filterType":"LOT_SIZE",
  #           "minQty":"0.00100000",
  #           "maxQty":"100000.00000000",
  #           "stepSize":"0.00100000"
  #         },
  #         {
  #           "filterType":"MIN_NOTIONAL",
  #           "minNotional":"0.00100000",
  #           "applyToMarket":true,
  #           "avgPriceMins":5
  #         },
  #         {
  #           "filterType":"ICEBERG_PARTS",
  #           "limit":10
  #         },
  #         {
  #           "filterType":"MARKET_LOT_SIZE",
  #           "minQty":"0.00000000",
  #           "maxQty":"63100.00000000",
  #           "stepSize":"0.00000000"
  #         },
  #         {
  #           "filterType":"MAX_NUM_ALGO_ORDERS",
  #           "maxNumAlgoOrders":5
  #         }
  #     ]
  #
  class ExchangeFilter
    include JSON::Serializable
    include JSON::Serializable::Unmapped

    def initialize; end

    @[JSON::Field(key: "filterType")]
    getter filter_type : String = ""

    def self.from_array(string : String)
      JSON.parse(string).as_a.map do |item|
        case item["filterType"]
        when "PRICE_FILTER"        then PriceFilter.from_json item.to_json
        when "PERCENT_PRICE"       then PercentPriceFilter.from_json item.to_json
        when "LOT_SIZE"            then LotSizeFilter.from_json item.to_json
        when "MIN_NOTIONAL"        then MinNotionalFilter.from_json item.to_json
        when "ICEBERG_PARTS"       then IcebergPartsFilter.from_json item.to_json
        when "MARKET_LOT_SIZE"     then MarketLotSizeFilter.from_json item.to_json
        when "MAX_NUM_ALGO_ORDERS" then MaxNumAlgoOrdersFilter.from_json item.to_json
        else                            ExchangeFilter.from_json item.to_json
        end
      end
    end
  end
end
