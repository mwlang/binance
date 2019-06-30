module Binance::Responses
  # Typical server response
  #     {
  #       "symbol": "BNBBTC",
  #       "priceChange": "-94.99999800",
  #       "priceChangePercent": "-95.960",
  #       "weightedAvgPrice": "0.29628482",
  #       "prevClosePrice": "0.10002000",
  #       "lastPrice": "4.00000200",
  #       "lastQty": "200.00000000",
  #       "bidPrice": "4.00000000",
  #       "askPrice": "4.00000200",
  #       "openPrice": "99.00000000",
  #       "highPrice": "100.00000000",
  #       "lowPrice": "0.10000000",
  #       "volume": "8913.30000000",
  #       "quoteVolume": "15.30000000",
  #       "openTime": 1499783499040,
  #       "closeTime": 1499869899040,
  #       "firstId": 28385,   // First tradeId
  #       "lastId": 28460,    // Last tradeId
  #       "count": 76         // Trade count
  #     }
  class TwentyFourHourEntry
    include JSON::Serializable

    @[JSON::Field(key: "symbol")]
    getter symbol : String = ""

    @[JSON::Field(key: "priceChange", converter: Binance::Converters::ToFloat)]
    getter price_change : Float64 = 0.0

    @[JSON::Field(key: "priceChangePercent", converter: Binance::Converters::ToFloat)]
    getter price_change_percent : Float64 = 0.0

    @[JSON::Field(key: "weightedAvgPrice", converter: Binance::Converters::ToFloat)]
    getter weighted_average_price : Float64 = 0.0

    @[JSON::Field(key: "prevClosePrice", converter: Binance::Converters::ToFloat)]
    getter prev_close_price : Float64 = 0.0

    @[JSON::Field(key: "lastPrice", converter: Binance::Converters::ToFloat)]
    getter last_price : Float64 = 0.0

    @[JSON::Field(key: "lastQty", converter: Binance::Converters::ToFloat)]
    getter last_quantity : Float64 = 0.0

    @[JSON::Field(key: "bidPrice", converter: Binance::Converters::ToFloat)]
    getter bid_price : Float64 = 0.0

    @[JSON::Field(key: "askPrice", converter: Binance::Converters::ToFloat)]
    getter ask_price : Float64 = 0.0

    @[JSON::Field(key: "openPrice", converter: Binance::Converters::ToFloat)]
    getter open_price : Float64 = 0.0

    @[JSON::Field(key: "highPrice", converter: Binance::Converters::ToFloat)]
    getter high_price : Float64 = 0.0

    @[JSON::Field(key: "lowPrice", converter: Binance::Converters::ToFloat)]
    getter low_price : Float64 = 0.0

    @[JSON::Field(key: "volume", converter: Binance::Converters::ToFloat)]
    getter base_volume : Float64 = 0.0

    @[JSON::Field(key: "quoteVolume", converter: Binance::Converters::ToFloat)]
    getter quote_volume : Float64 = 0.0

    @[JSON::Field(key: "openTime", converter: Binance::Converters::ToTime)]
    getter open_time : Time?

    @[JSON::Field(key: "closeTime", converter: Binance::Converters::ToTime)]
    getter close_time : Time?

    @[JSON::Field(key: "firstId")]
    getter first_id : Int32 = 0

    @[JSON::Field(key: "lastId")]
    getter last_id : Int32 = 0

    @[JSON::Field(key: "count")]
    getter trades : Int32 = 0
  end
end
