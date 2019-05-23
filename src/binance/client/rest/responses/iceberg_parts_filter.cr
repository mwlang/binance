module Binance::Responses
  # Typical server response
  #     {
  #       "filterType":"ICEBERG_PARTS",
  #       "limit":10
  #     }
  class IcebergPartsFilter < ExchangeFilter
    @[JSON::Field(key: "limit")]
    getter limit : Int32 = 0
  end
end