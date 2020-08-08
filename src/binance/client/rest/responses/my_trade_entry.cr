module Binance::Responses
  # Typical server response
  #     {
  #       "symbol": "BNBBTC",
  #       "id": 28457,
  #       "orderId": 100234,
  #       "price": "4.00000100",
  #       "qty": "12.00000000",
  #       "quoteQty": "48.000012",
  #       "commission": "10.10000000",
  #       "commissionAsset": "BNB",
  #       "time": 1499865549590,
  #       "isBuyer": true,
  #       "isMaker": false,
  #       "isBestMatch": true
  #     }
  class MyTradeEntry
    include JSON::Serializable

    @[JSON::Field(key: "symbol")]
    getter symbol : String?

    @[JSON::Field(key: "id")]
    getter trade_id : Int32

    @[JSON::Field(key: "orderId")]
    getter order_id : Int32

    @[JSON::Field(key: "price", converter: Binance::Converters::ToFloat)]
    getter price : Float64

    @[JSON::Field(key: "qty", converter: Binance::Converters::ToFloat)]
    getter quantity : Float64

    @[JSON::Field(key: "quoteQty", converter: Binance::Converters::ToFloat)]
    getter quote_quantity : Float64

    @[JSON::Field(key: "time", converter: Binance::Converters::ToTime)]
    getter time : ::Time = ::Time.utc

    @[JSON::Field(key: "isBuyer")]
    getter is_buyer : Bool

    @[JSON::Field(key: "isMaker")]
    getter is_maker : Bool

    @[JSON::Field(key: "isBestMatch")]
    getter is_best_match : Bool
  end
end
