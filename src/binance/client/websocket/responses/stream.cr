module Binance::Responses::Websocket
  class Stream

    getter stream : String = ""
    getter symbol : String = ""
    getter name : String = ""

    getter data : (Binance::Responses::Websocket::Data)

    def initialize(stream : String, symbol : String, name : String, data)
      @stream = stream
      @symbol = symbol
      @name = name
      @data = data
    end

    def self.new(pull : JSON::PullParser)
      pull.read_begin_object
      pull.read_next
      stream = pull.read_string
      pull.read_next
      symbol, _, name = stream.partition('@')

      data = case name
      when "ticker"     then  Ticker.new(pull)
      when "miniTicker" then  MiniTicker.new(pull)
      when "trade"      then  Trade.new(pull)
      else                    Data.new(pull)
      end

      new stream, symbol.upcase, name, data
    end

    def ticker
      @data.as(Ticker)
    end

    def mini_ticker
      @data.as(MiniTicker)
    end

    def trade
      @data.as(Trade)
    end

    # def self.from_data(pull : JSON::PullParser)

    #   case item["filterType"]
    #   when "PRICE_FILTER"        then PriceFilter.from_json item.to_json
    #   when "PERCENT_PRICE"       then PercentPriceFilter.from_json item.to_json
    #   when "LOT_SIZE"            then LotSizeFilter.from_json item.to_json
    #   when "MIN_NOTIONAL"        then MinNotionalFilter.from_json item.to_json
    #   when "ICEBERG_PARTS"       then IcebergPartsFilter.from_json item.to_json
    #   when "MARKET_LOT_SIZE"     then MarketLotSizeFilter.from_json item.to_json
    #   when "MAX_NUM_ALGO_ORDERS" then MaxNumAlgoOrdersFilter.from_json item.to_json
    #   else                            ExchangeFilter.from_json item.to_json
    #   end
    # end


  end
end
