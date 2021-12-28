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

    def self.extract_all_stream(stream, pull)
      data = Data.new(pull)

      case stream
      when "!bookTicker"      then BookTicker.from_data(data)
      when "!miniTicker@arr"  then MiniTicker.from_data(data)
      when "!ticker@arr"      then Ticker.from_data(data)
      else data
      end
    end

    def self.new(pull : JSON::PullParser)
      pull.read_begin_object
      pull.read_next
      stream = pull.read_string
      pull.read_next
      symbol, a, name = stream.partition('@')
      data = case name
      when "ticker"      then  Ticker.new(pull)
      when "miniTicker"  then  MiniTicker.new(pull)
      when "trade"       then  Trade.new(pull)
      when "aggTrade"    then  AggregateTrade.new(pull)
      when "bookTicker"  then  BookTicker.new(pull)
      when /^depth\d+$/  then  PartialDepth.new(pull).tap{|pd| pd.symbol = symbol.upcase}
      when /^depth/      then  Depth.new(pull)
      when /^kline/      then  Kline.new(pull)
      else extract_all_stream(stream, pull)
      end

      new stream, symbol.upcase, name, data
    end

    macro stream(name, response_klass)
      def {{name}}
        @data.as({{response_klass}})
      end
      def {{name}}?
        @data.is_a?({{response_klass}}) ? @data.as({{response_klass}}) : nil
      end
    end

    stream kline, Kline
    stream trade, Trade
    stream aggregate_trade, AggregateTrade
    stream depth, Depth
    stream partial_depth, PartialDepth
    stream book_ticker, BookTicker
    stream ticker, Ticker
    stream mini_ticker, MiniTicker
  end
end
