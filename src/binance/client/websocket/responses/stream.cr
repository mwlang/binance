module Binance::Responses::Websocket
  class Stream

    getter stream : String = ""
    getter symbol : String = ""
    getter name : String = ""

    getter data : Data

    def initialize(stream : String, symbol : String, name : String, data : Data)
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

  end
end
