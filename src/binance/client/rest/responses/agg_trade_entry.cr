module Binance::Responses
  # Typical server response
  #   {
  #     "a": 26129,         // Aggregate tradeId
  #     "p": "0.01633102",  // Price
  #     "q": "4.70443515",  // Quantity
  #     "f": 27781,         // First tradeId
  #     "l": 27781,         // Last tradeId
  #     "T": 1498793709153, // Timestamp
  #     "m": true,          // Was the buyer the maker?
  #     "M": true           // Was the trade the best price match?
  #   }
  class AggTradeEntry
    include JSON::Serializable

    @[JSON::Field(key: "a")]
    getter trade_id : Int64

    @[JSON::Field(key: "p", converter: Binance::Converters::ToFloat)]
    getter price : Float64

    @[JSON::Field(key: "q", converter: Binance::Converters::ToFloat)]
    getter quantity : Float64

    @[JSON::Field(key: "f")]
    getter first_trade_id : Int64

    @[JSON::Field(key: "l")]
    getter last_trade_id : Int64

    @[JSON::Field(key: "T", converter: Binance::Converters::ToTime)]
    getter time : ::Time = ::Time.utc

    @[JSON::Field(key: "m")]
    getter is_buyer_maker : Bool

    @[JSON::Field(key: "M")]
    getter is_best_match : Bool
  end
end
