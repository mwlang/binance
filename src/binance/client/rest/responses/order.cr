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
  #
  # price used to be filled, now it seems to always be 0.0
  #
  # Change log 2018-07-18 states:
  #
  # cummulativeQuoteQty field added to order responses and execution reports
  # (as variable Z). Represents the cummulative amount of the quote that has been
  # spent (with a BUY order) or received (with a SELL order). Historical orders will
  # have a value < 0 in this field indicating the data is not available at this time.
  #
  # cummulativeQuoteQty divided by cummulativeQty will give the average price for an order.
  #
  # NOTE: I am not sure exactly what this means, so there are two test specs
  # The original spec in order_spec still has original cassette (signed, so not committed to repo)
  # where price was conveyed, but cummulativeQuoteQty is zero
  # New spec is in new_order_spec and it captures what is apparent current behavior
  #
  # `average_price` implements the above price calculation
  # `effective_fill_price` computes from all the fills on the order, but order must be placed
  # with `responseType = "FULL"` to get that data on placing market orders.
  #
  class Order
    include JSON::Serializable

    @[JSON::Field(key: "symbol")]
    getter symbol : String = ""

    @[JSON::Field(key: "orderId")]
    getter order_id : Int32 = 0

    @[JSON::Field(key: "origClientOrderId")]
    getter orig_client_order_id : String = ""

    @[JSON::Field(key: "clientOrderId")]
    getter client_order_id : String = ""

    @[JSON::Field(key: "transactTime", converter: Binance::Converters::ToTime)]
    getter transaction_time : Time = Time.utc

    @[JSON::Field(key: "price", converter: Binance::Converters::ToFloat)]
    getter price : Float64 = 0.0

    @[JSON::Field(key: "origQty", converter: Binance::Converters::ToFloat)]
    getter original_quantity : Float64 = 0.0

    @[JSON::Field(key: "executedQty", converter: Binance::Converters::ToFloat)]
    getter executed_quantity : Float64 = 0.0

    @[JSON::Field(key: "cummulativeQuoteQty", converter: Binance::Converters::ToFloat)]
    getter cummulative_quote_quantity : Float64 = 0.0

    @[JSON::Field(key: "status")]
    getter status : String = "NEW"

    @[JSON::Field(key: "timeInForce")]
    getter time_in_force : String = ""

    @[JSON::Field(key: "type")]
    getter order_type : String = ""

    @[JSON::Field(key: "side")]
    getter side : String = ""

    @[JSON::Field(key: "stopPrice", converter: Binance::Converters::ToFloat)]
    getter stop_price : Float64 = 0.0

    @[JSON::Field(key: "fills")]
    getter fills : Array(OrderFill) = [] of Binance::Responses::OrderFill

    def average_price
      return price if price > 0.0
      return 0.0 if cummulative_quote_quantity < 0.0 || executed_quantity == 0.0

      cummulative_quote_quantity / executed_quantity
    end

    def effective_fill_price
      return @price if @price > 0.0
      total_fill_price = fills.reduce(0.0){|sum, fill| sum + (fill.price * fill.quantity)}
      total_fill_quantity = fills.reduce(0.0){|sum, fill| sum + fill.quantity}
      total_fill_price / total_fill_quantity
    end
  end
end
