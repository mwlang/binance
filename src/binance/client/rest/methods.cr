module Binance::Methods
  include Binance::Responses

  # Returns: `PingResponse`
  def ping
    fetch :public, :ping, PingResponse
  end

  # Returns `TimeResponse`
  def time
    fetch :public, :time, TimeResponse
  end

  # Returns `ExchangeInfoResponse`
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

  def order(
      symbol : String,
      order_id : Int32? = nil
    )

    params = HTTP::Params.new
    params["symbol"] = symbol.upcase
    oid = order_id
    params["orderId"] = oid.to_s unless oid.nil?

    fetch :signed, :order, OrderResponse, params
  end

  def open_orders(symbol : String)
    fetch :signed, :open_orders, OrderResponse, {symbol: symbol.upcase}
  end

  def account
    fetch :signed, :account, AccountResponse
  end
end
