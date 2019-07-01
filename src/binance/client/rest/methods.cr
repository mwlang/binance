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

  def twenty_four_hour(symbol : String)
    fetch :public, :twenty_four_hour, TwentyFourHourResponse, {symbol: symbol.upcase}
  end

  def twenty_four_hour
    fetch :public, :twenty_four_hour, TwentyFourHourResponse
  end

  def price(symbol : String)
    fetch :public, :price, PriceResponse, {symbol: symbol.upcase}
  end

  def price
    fetch :public, :price, PriceResponse
  end

  def book_ticker(symbol : String)
    fetch :public, :book_ticker, BookTickerResponse, {symbol: symbol.upcase}
  end

  def book_ticker
    fetch :public, :book_ticker, BookTickerResponse
  end

  def historical_trades(symbol : String, limit : Int32 = 500)
    fetch :verified, :historical_trades, TradesResponse, {symbol: symbol.upcase, limit: limit}
  end

  # Name        Type    Mandatory   Description
  # symbol      STRING  YES 
  # fromId      LONG    NO          ID to get aggregate trades from INCLUSIVE.
  # startTime   LONG    NO          Timestamp in ms to get aggregate trades from INCLUSIVE.
  # endTime     LONG    NO          Timestamp in ms to get aggregate trades until INCLUSIVE.
  # limit       INT     NO          Default 500; max 1000.
  #
  #   * If both startTime and endTime are sent, time between startTime and endTime must be less than 1 hour.
  #   * If fromId, startTime, and endTime are not sent, the most recent aggregate trades will be returned.
  def agg_trades(
      symbol : String, 
      limit : Int32 = 500,
      from_id : Int32 = 0, 
      start_time : Time? = nil, 
      end_time : Time? = nil
    )

    params = {} of Symbol => String | Int32 | Time
    params[:symbol] = symbol
    params[:limit] = limit

    params[:fromId] = from_id unless from_id.zero?
    ts = start_time
    params[:startTime] = ts.to_unix_ms unless ts.nil?
    ts = end_time
    params[:endTime] = ts.to_unix_ms unless ts.nil?

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
    
    params = {} of Symbol => String | Int32 | Time

    params[:symbol] = symbol
    params[:limit] = limit
    params[:interval] = interval

    ts = start_time
    params[:startTime] = ts.to_unix_ms unless ts.nil?
    ts = end_time
    params[:endTime] = ts.to_unix_ms unless ts.nil?

    fetch :public, :klines, KlinesResponse, params
  end
end
