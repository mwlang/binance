module Binance::Responses

  # Typical Server Response:
  #     {
  #       "timezone": "UTC",
  #       "serverTime": 1508631584636,
  #       "rateLimits": [
  #         // These are defined in the `ENUM definitions` section under `Rate limiters (rateLimitType)`.
  #         // All limits are optional.
  #       ],
  #       "exchangeFilters": [
  #         // There are defined in the `Filters` section.
  #         // All filters are optional.
  #       ],
  #       "symbols": [{
  #         "symbol": "ETHBTC",
  #         "status": "TRADING",
  #         "baseAsset": "ETH",
  #         "baseAssetPrecision": 8,
  #         "quoteAsset": "BTC",
  #         "quotePrecision": 8,
  #         "orderTypes": [
  #           // These are defined in the `ENUM definitions` section under `Order types (orderTypes)`.
  #           // All orderTypes are optional.
  #         ],
  #         "icebergAllowed": false,
  #         "filters": [
  #           // There are defined in the `Filters` section.
  #           // All filters are optional.
  #         ]
  #       }]
  #     }  
  class ExchangeInfoResponse < ServerResponse
    @[JSON::Field(key: "timezone")]
    # Time Zone for server's time values
    getter timezone : String = "UTC"

    @[JSON::Field(key: "serverTime", converter: Binance::Converters::ToTime)]
    # A `Time` representation of the serverTime property
    getter server_time : ::Time = ::Time.now

    @[JSON::Field(key: "rateLimits")]
    getter rate_limits : Array(Binance::Responses::RateLimit) = [] of Binance::Responses::RateLimit

    @[JSON::Field(key: "exchangeFilters")]
    getter exchange_filters : Array(Binance::Responses::ExchangeFilter) = [] of Binance::Responses::ExchangeFilter
  
    @[JSON::Field(key: "symbols")]
    getter symbols : Array(Binance::Responses::ExchangeSymbol) = [] of Binance::Responses::ExchangeSymbol
  end
end