module Binance::Endpoints
  include Binance::Responses

  def symbol_param(params : HTTP::Params, value : String | Nil)
    if (v = value) && !v.nil?
      params["symbol"] = v.upcase
    end
  end

  def optional_param(params : HTTP::Params, key : String, value : Nil)
    # NOP
  end

  def optional_param(params : HTTP::Params, key : String, value : String)
    params[key] = value
  end

  def optional_param(params : HTTP::Params, key : String, value : Float64 | Int32 | Int64)
    params[key] = value.to_s
  end

  def optional_param(params : HTTP::Params, key : String, value : Time)
    params[key] = value.to_unix_ms.to_s
  end

  macro fetch(action, client, endpoint, response_klass, params = HTTP::Params.new)
    begin
      if response = {{client.id}}_{{action.id}}(Binance::Endpoints::ENDPOINTS[{{endpoint}}], {{params}})
        if response.status_code == 200
          {{response_klass}}.from_json(response.body).tap do |resp|
            resp.response = response
          end
        else
          {{response_klass}}.from_error(response)
        end
      else
        {{response_klass}}.from_failure(response)
      end
    rescue ex : Exception
      {{response_klass}}.from_exception(ex)
    end
  end

  ENDPOINTS = {
    # Public API Endpoints
    ping:              "v1/ping",
    time:              "v1/time",
    exchange_info:     "v3/exchangeInfo",
    depth:             "v3/depth",
    trades:            "v1/trades",
    historical_trades: "v1/historicalTrades",
    agg_trades:        "v1/aggTrades",
    klines:            "v3/klines",
    twenty_four_hour:  "v1/ticker/24hr",
    price:             "v3/ticker/price",
    avg_price:         "v3/avgPrice",
    book_ticker:       "v3/ticker/bookTicker",

    # Account API Endpoints
    new_order:        "v3/order",
    get_order:        "v3/order",
    cancel_order:     "v3/order",
    new_test_order:   "v3/order/test",
    open_orders:      "v3/openOrders",
    all_orders:       "v3/allOrders",
    account:          "v3/account",
    my_trades:        "v3/myTrades",
    user_data_stream: "v1/userDataStream",

    # Withdraw API Endpoints
    withdraw:         "v3/withdraw.html",
    deposit_history:  "v3/depositHistory.html",
    withdraw_history: "v3/withdrawHistory.html",
    deposit_address:  "v3/depositAddress.html",
    account_status:   "v3/accountStatus.html",
    system_status:    "v3/systemStatus.html",
    withdraw_fee:     "v3/withdrawFee.html",
    dust_log:         "v3/userAssetDribbletLog.html",
  }

  def ping
    fetch :get, :public, :ping, PingResponse
  end

  def time
    fetch :get, :public, :time, TimeResponse
  end

  def exchange_info
    fetch :get, :public, :exchange_info, ExchangeInfoResponse
  end

  def depth(symbol : String, limit : Int32 = 5)
    params = HTTP::Params.new
    symbol_param params, symbol
    params["limit"] = limit.to_s

    fetch :get, :public, :depth, DepthResponse, params
  end

  def trades(symbol : String, limit : Int32 = 500)
    params = HTTP::Params.new
    symbol_param params, symbol
    params["limit"] = limit.to_s

    fetch :get, :public, :trades, TradesResponse, params
  end

  def avg_price(symbol : String)
    params = HTTP::Params.new
    symbol_param params, symbol

    fetch :get, :public, :avg_price, AvgPriceResponse, params
  end

  def twenty_four_hour(symbol : String? = nil)
    params = HTTP::Params.new
    symbol_param params, symbol

    fetch :get, :public, :twenty_four_hour, TwentyFourHourResponse, params
  end

  def price(symbol : String? = nil)
    params = HTTP::Params.new
    symbol_param params, symbol

    fetch :get, :public, :price, PriceResponse, params
  end

  def book_ticker(symbol : String? = nil)
    params = HTTP::Params.new
    symbol_param params, symbol

    fetch :get, :public, :book_ticker, BookTickerResponse, params
  end

  def historical_trades(symbol : String, limit : Int32 = 500)
    params = HTTP::Params.new
    symbol_param params, symbol
    params["limit"] = limit.to_s

    fetch :get, :verified, :historical_trades, TradesResponse, params
  end

  # Name       | Type   | Mandatory  | Description
  # -----------|--------|------------|------------
  # symbol     | STRING | YES        |
  # fromId     | LONG   | NO         | ID to get aggregate trades from INCLUSIVE.
  # startTime  | LONG   | NO         | Timestamp in ms to get aggregate trades from INCLUSIVE.
  # endTime    | LONG   | NO         | Timestamp in ms to get aggregate trades until INCLUSIVE.
  # limit      | INT    | NO         | Default 500; max 1000.
  #
  #   * If both startTime and endTime are sent, time between startTime and endTime must be less than 1 hour.
  #   * If fromId, startTime, and endTime are not sent, the most recent aggregate trades will be returned.
  def agg_trades(
    symbol : String,          # The market symbol to query
    limit : Int32 = 500,      # Number of entries to return. Default 500; max 1000.
    from_id : Int64? = nil,   # ID to get aggregate trades from INCLUSIVE.
    start_time : Time? = nil, # Timestamp in ms to get aggregate trades from INCLUSIVE.
    end_time : Time? = nil    # Timestamp in ms to get aggregate trades until INCLUSIVE.
  )
    params = HTTP::Params.new
    symbol_param params, symbol
    params["limit"] = limit.to_s

    optional_param params, "fromId", from_id
    optional_param params, "startTime", start_time
    optional_param params, "endTime", end_time

    fetch :get, :public, :agg_trades, AggTradesResponse, params
  end

  # Name        Type    Mandatory   Description
  # symbol      STRING  YES
  # interval    ENUM    YES
  # startTime   LONG    NO
  # endTime     LONG    NO
  # limit       INT     NO          Default 500; max 1000.
  #
  #   * If startTime and endTime are not sent, the most recent klines are returned.
  def klines(
    symbol : String,
    interval : String,
    limit : Int32 = 500,
    start_time : Time? = nil,
    end_time : Time? = nil
  )
    params = HTTP::Params.new

    symbol_param params, symbol
    params["limit"] = limit.to_s
    params["interval"] = interval

    optional_param params, "startTime", start_time
    optional_param params, "endTime", end_time

    fetch :get, :public, :klines, KlinesResponse, params
  end

  # Get all account orders; active, canceled, or filled.
  #
  # Name        Type    Mandatory Description
  # symbol      STRING  YES
  # orderId     LONG    NO
  # startTime   LONG    NO
  # endTime     LONG    NO
  # limit       INT     NO        Default 500; max 1000.
  # recvWindow  LONG    NO
  # timestamp   LONG    YES
  #
  # Notes:
  # * If orderId is set, it will get orders >= that orderId. Otherwise most recent orders are returned.
  # * For some historical orders cummulativeQuoteQty will be < 0, meaning the data is not available at this time.
  def all_orders(
    symbol : String,
    order_id : Int64? = nil,
    limit : Int32 = 500,
    start_time : Time? = nil,
    end_time : Time? = nil
  )
    params = HTTP::Params.new

    symbol_param params, symbol
    params["limit"] = limit.to_s

    optional_param params, "orderId", order_id
    optional_param params, "startTime", start_time
    optional_param params, "endTime", end_time

    fetch :get, :signed, :all_orders, OrderResponse, params
  end

  # Send in a new order.
  #
  # Parameters:
  #
  # * Name              Type    Mandatory Description
  # * symbol            STRING  YES
  # * side              ENUM    YES
  # * type              ENUM    YES
  # * timeInForce       ENUM    NO
  # * quantity          DECIMAL YES
  # * price             DECIMAL NO
  # * newClientOrderId  STRING  NO  A unique id for the order. Automatically generated if not sent.
  # * stopPrice         DECIMAL NO  Used with STOP_LOSS, STOP_LOSS_LIMIT, TAKE_PROFIT, and TAKE_PROFIT_LIMIT orders.
  # * icebergQty        DECIMAL NO  Used with LIMIT, STOP_LOSS_LIMIT, and TAKE_PROFIT_LIMIT to create an iceberg order.
  # * newOrderRespType  ENUM    NO  Set the response JSON. ACK, RESULT, or FULL; MARKET and LIMIT order types default to FULL, all other orders default to ACK.
  # * recvWindow        LONG    NO
  # * timestamp         LONG    YES
  #
  # Additional mandatory parameters based on type:
  #
  # * Type  Additional mandatory parameters
  # * LIMIT timeInForce, quantity, price
  # * MARKET  quantity
  # * STOP_LOSS quantity, stopPrice
  # * STOP_LOSS_LIMIT timeInForce, quantity, price, stopPrice
  # * TAKE_PROFIT quantity, stopPrice
  # * TAKE_PROFIT_LIMIT timeInForce, quantity, price, stopPrice
  # * LIMIT_MAKER quantity, price
  #
  # Other info:
  #
  # * LIMIT_MAKER are LIMIT orders that will be rejected if they would immediately match and trade as a taker.
  # * STOP_LOSS and TAKE_PROFIT will execute a MARKET order when the stopPrice is reached.
  # * Any LIMIT or LIMIT_MAKER type order can be made an iceberg order by sending an icebergQty.
  # * Any order with an icebergQty MUST have timeInForce set to GTC.
  # * Trigger order price rules against market price for both MARKET and LIMIT versions:
  #
  # * Price above market price: STOP_LOSS BUY, TAKE_PROFIT SELL
  # * Price below market price: STOP_LOSS SELL, TAKE_PROFIT BUY
  #
  def new_order(
    symbol : String,
    side : String,
    order_type : String,
    quantity : (Float64 | String),
    time_in_force : String? = nil,
    price : Float64? = nil,
    client_order_id : String? = nil,
    stop_price : Float64? = nil,
    iceberg_quantity : Float64? = nil,
    response_type : String? = nil
  )
    params = HTTP::Params.new
    symbol_param params, symbol
    params["side"] = side.upcase
    params["type"] = order_type.upcase
    params["quantity"] = quantity.to_s
    optional_param params, "timeInForce", time_in_force
    optional_param params, "price", price
    optional_param params, "newClientOrderId", client_order_id
    optional_param params, "stopPrice", stop_price
    optional_param params, "icebergQty", iceberg_quantity
    optional_param params, "newOrderRespType", response_type

    fetch :post, :signed, :new_order, OrderResponse, params
  end

  def new_test_order(
    symbol : String,
    side : String,
    order_type : String,
    quantity : (Float64 | String),
    time_in_force : String? = nil,
    price : Float64? = nil,
    client_order_id : String? = nil,
    stop_price : Float64? = nil,
    iceberg_quantity : Float64? = nil,
    response_type : String? = nil
  )
    params = HTTP::Params.new
    symbol_param params, symbol
    params["side"] = side.upcase
    params["type"] = order_type.upcase
    params["quantity"] = quantity.to_s
    optional_param params, "timeInForce", time_in_force
    optional_param params, "price", price
    optional_param params, "newClientOrderId", client_order_id
    optional_param params, "stopPrice", stop_price
    optional_param params, "icebergQty", iceberg_quantity
    optional_param params, "newOrderRespType", response_type

    fetch :post, :signed, :new_test_order, OrderResponse, params
  end

  # Check an order's status
  #
  #   Name              Type    Mandatory Description
  #   symbol            STRING  YES
  #   orderId           LONG    NO
  #   origClientOrderId STRING  NO
  #   recvWindow        LONG    NO
  #   timestamp         LONG    YES
  #
  # * Either orderId or origClientOrderId must be sent.
  # * For some historical orders cummulativeQuoteQty will be < 0, meaning the data is not available at this time.
  #
  def get_order(
    symbol : String,
    order_id : (Int32 | Int64)? = nil,
    client_order_id : String? = nil
  )
    params = HTTP::Params.new
    symbol_param params, symbol

    optional_param params, "orderId", order_id
    optional_param params, "origClientOrderId", client_order_id

    fetch :get, :signed, :get_order, OrderResponse, params
  end

  # Cancel an active order
  #
  #   Name              Type    Mandatory Description
  #   symbol            STRING  YES
  #   orderId           LONG    NO
  #   origClientOrderId STRING  NO
  #   recvWindow        LONG    NO
  #   timestamp         LONG    YES
  #
  # * Either orderId or origClientOrderId must be sent.
  #
  def cancel_order(
    symbol : String,
    order_id : (Int32 | Int64)? = nil,
    client_order_id : String? = nil
  )
    params = HTTP::Params.new
    symbol_param params, symbol

    optional_param params, "orderId", order_id
    optional_param params, "origClientOrderId", client_order_id

    fetch :delete, :signed, :cancel_order, OrderResponse, params
  end

  def open_orders(symbol : String)
    params = HTTP::Params.new
    symbol_param params, symbol

    fetch :get, :signed, :open_orders, OrderResponse, params
  end

  def account
    fetch :get, :signed, :account, AccountResponse
  end

  # Get trades for a specific account and symbol.
  #
  # Name  Type  Mandatory Description
  # symbol  STRING  YES
  # startTime LONG  NO
  # endTime LONG  NO
  # fromId  LONG  NO  TradeId to fetch from. Default gets most recent trades.
  # limit INT NO  Default 500; max 1000.
  # recvWindow  LONG  NO
  # timestamp LONG  YES
  # Notes:
  #
  # * If fromId is set, it will get orders >= that fromId. Otherwise most recent orders are returned.
  #
  def my_trades(
    symbol : String,          # The market symbol to query
    limit : Int32 = 500,      # Number of entries to return. Default 500; max 1000.
    from_id : Int64? = nil,   # TradeId to fetch from. Default gets most recent trades.
    start_time : Time? = nil, # Timestamp in ms to get aggregate trades from INCLUSIVE.
    end_time : Time? = nil    # Timestamp in ms to get aggregate trades until INCLUSIVE.
  )
    params = HTTP::Params.new
    symbol_param params, symbol
    params["limit"] = limit.to_s

    optional_param params, "fromId", from_id
    optional_param params, "startTime", start_time
    optional_param params, "endTime", end_time

    fetch :get, :signed, :my_trades, MyTradesResponse, params
  end
end
