module Binance::Endpoints
  include Binance::Responses

  ENDPOINTS = {
    # Public API Endpoints
    ping:              "v1/ping",
    time:              "v1/time",
    exchange_info:     "v1/exchangeInfo",
    depth:             "v1/depth",
    trades:            "v1/trades",
    historical_trades: "v1/historicalTrades",
    agg_trades:        "v1/aggTrades",
    klines:            "v1/klines",
    twenty_four_hour:  "v1/ticker/24hr",
    price:             "v3/ticker/price",
    avg_price:         "v3/avgPrice",
    book_ticker:       "v3/ticker/bookTicker",

    # Account API Endpoints
    order:            "v3/order",
    test_order:       "v3/order/test",
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
    dust_log:         "v3/userAssetDribbletLog.html"
  }

  def ping
    fetch :public, :ping, PingResponse
  end

  def time
    fetch :public, :time, TimeResponse
  end

  def exchange_info
    fetch :public, :exchange_info, ExchangeInfoResponse
  end

  def depth(symbol : String, limit : Int32 = 5)
    fetch :public, :depth, DepthResponse, {symbol: symbol.upcase, limit: limit}
  end

  def trades(symbol : String, limit : Int32 = 500)
    fetch :public, :trades, TradesResponse, {symbol: symbol.upcase, limit: limit}
  end

  def avg_price(symbol : String)
    fetch :public, :avg_price, AvgPriceResponse, {symbol: symbol.upcase}
  end

  def twenty_four_hour(symbol : String? = nil)
    params = HTTP::Params.new
    symb = symbol
    params["symbol"] = symb.upcase unless (symb).nil?

    fetch :public, :twenty_four_hour, TwentyFourHourResponse, params
  end

  def price(symbol : String? = nil)
    params = HTTP::Params.new
    symb = symbol
    params["symbol"] = symb.upcase unless (symb).nil?

    fetch :public, :price, PriceResponse, params
  end

  def book_ticker(symbol : String? = nil)
    params = HTTP::Params.new
    symb = symbol
    params["symbol"] = symb.upcase unless (symb).nil?

    fetch :public, :book_ticker, BookTickerResponse, params
  end

  def historical_trades(symbol : String, limit : Int32 = 500)
    fetch :verified, :historical_trades, TradesResponse, {symbol: symbol.upcase, limit: limit}
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
      symbol : String,           # The market symbol to query
      limit : Int32 = 500,       # Number of entries to return. Default 500; max 1000.
      from_id : Int32 = 0,       # ID to get aggregate trades from INCLUSIVE.
      start_time : Time? = nil,  # Timestamp in ms to get aggregate trades from INCLUSIVE.
      end_time : Time? = nil     # Timestamp in ms to get aggregate trades until INCLUSIVE.
    )

    params = HTTP::Params.new
    params["symbol"] = symbol.upcase
    params["limit"] = limit.to_s

    params["fromId"] = from_id.to_s unless from_id.zero?
    ts = start_time
    params["startTime"] = ts.to_unix_ms.to_s unless ts.nil?
    ts = end_time
    params["endTime"] = ts.to_unix_ms.to_s unless ts.nil?

    fetch :public, :agg_trades, AggTradesResponse, params
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

    params["symbol"] = symbol.upcase
    params["limit"] = limit.to_s
    params["interval"] = interval

    ts = start_time
    params["startTime"] = ts.to_unix_ms.to_s unless ts.nil?
    ts = end_time
    params["endTime"] = ts.to_unix_ms.to_s unless ts.nil?

    fetch :public, :klines, KlinesResponse, params
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
      order_id : Int32? = nil,
      limit : Int32 = 500,
      start_time : Time? = nil, 
      end_time : Time? = nil
    )
    
    params = HTTP::Params.new

    params["symbol"] = symbol.upcase
    params["limit"] = limit.to_s

    oid = order_id
    params["order_id"] = oid.to_s unless oid.nil?

    ts = start_time
    params["startTime"] = ts.to_unix_ms.to_s unless ts.nil?
    ts = end_time
    params["endTime"] = ts.to_unix_ms.to_s unless ts.nil?

    fetch :signed, :all_orders, OrderResponse, params
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
  def order(
      symbol : String,
      order_id : Int32? = nil,
      original_client_order_id : String? = nil
    )

    params = HTTP::Params.new
    params["symbol"] = symbol.upcase

    oid = order_id
    params["orderId"] = oid.to_s unless oid.nil?

    ocoid = original_client_order_id
    params["origClientOrderId"] = ocoid unless ocoid.nil?

    fetch :signed, :order, OrderResponse, params
  end

  def open_orders(symbol : String)
    fetch :signed, :open_orders, OrderResponse, {symbol: symbol.upcase}
  end

  def account
    fetch :signed, :account, AccountResponse
  end

end