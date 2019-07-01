module Binance::Responses
  # Typical Server Response:
  #     {
  #       "symbol": "LTCBTC",
  #       "orderId": 28,
  #       "origClientOrderId": "myOrder1",
  #       "clientOrderId": "cancelMyOrder1",
  #       "transactTime": 1507725176595,
  #       "price": "1.00000000",
  #       "origQty": "10.00000000",
  #       "executedQty": "8.00000000",
  #       "cummulativeQuoteQty": "8.00000000",
  #       "status": "CANCELED",
  #       "timeInForce": "GTC",
  #       "type": "LIMIT",
  #       "side": "SELL"
  #     }
  class OrderEntry
    include JSON::Serializable

    @[JSON::Field(key: "symbol")]
    getter symbol : String = ""

    @[JSON::Field(key: "orderId")]
    getter order_id : Int32? = nil

    @[JSON::Field(key: "origClientOrderId")]
    getter orig_client_order_id : String = ""

    @[JSON::Field(key: "clientOrderId")]
    getter client_order_id : String = ""

    @[JSON::Field(key: "transactTime", converter: Binance::Converters::ToTime)]
    getter transact_time : Time = Time.now

    @[JSON::Field(key: "price", converter: Binance::Converters::ToFloat)]
    getter price : Float64 = 0.0

    @[JSON::Field(key: "origQty", converter: Binance::Converters::ToFloat)]
    getter original_quantity : Float64 = 0.0

    @[JSON::Field(key: "executedQty", converter: Binance::Converters::ToFloat)]
    getter executed_quantity : Float64 = 0.0

    @[JSON::Field(key: "cummulativeQuoteQty", converter: Binance::Converters::ToFloat)]
    getter cummulative_quote_quantity : Float64 = 0.0

    @[JSON::Field(key: "status")]
    getter status : String = ""

    @[JSON::Field(key: "timeInForce")]
    getter time_in_force : String = ""

    @[JSON::Field(key: "type")]
    getter order_type : String = ""

    @[JSON::Field(key: "side")]
    getter side : String = ""

    @[JSON::Field(key: "stopPrice", converter: Binance::Converters::ToFloat)]
    getter stop_price : Float64 = 0.0


  end
end
