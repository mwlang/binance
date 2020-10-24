
describe Binance::Responses::Websocket::Stream do
  context "ticker" do
    ticker_json = <<-JSON
      {
        "stream":"btcusdt@ticker",
        "data":{
          "e":"24hrTicker",
          "E":1598127580715,
          "s":"BTCUSDT",
          "p":"-115.32000000",
          "P":"-0.986",
          "w":"11539.47825399",
          "x":"11692.98000000",
          "c":"11577.55000000",
          "Q":"0.08326000",
          "b":"11577.55000000",
          "B":"2.34161000",
          "a":"11577.56000000",
          "A":"1.93661500",
          "o":"11692.87000000",
          "h":"11709.10000000",
          "l":"11376.81000000",
          "v":"50129.48441400",
          "q":"578468095.27887401",
          "O":1598041180596,
          "C":1598127580596,
          "F":391750555,
          "L":392664752,
          "n":914198
        }
      }
    JSON

    it "parses" do
      stream = Binance::Responses::Websocket::Stream.from_json(ticker_json)

      stream.stream.should eq "btcusdt@ticker"
      stream.name.should eq "ticker"
      stream.symbol.should eq "BTCUSDT"
      stream.data.should be_a Binance::Responses::Websocket::Ticker
      stream.ticker.symbol.should eq "BTCUSDT"
      stream.ticker.open_price.should eq 11692.87
      stream.ticker.last_price.should eq 11577.55
    end
  end

  context "mini_ticker" do
    mini_ticker_json = <<-JSON
      {
        "stream":"bnbbtc@miniTicker",
        "data":{
          "e": "24hrMiniTicker",
          "E": 1598127580715,
          "s": "BNBBTC",
          "c": "0.0025",
          "o": "0.0010",
          "h": "0.0025",
          "l": "0.0010",
          "v": "10000",
          "q": "18"
        }
      }
    JSON

    it "parses" do
      stream = Binance::Responses::Websocket::Stream.from_json(mini_ticker_json)

      stream.stream.should eq "bnbbtc@miniTicker"
      stream.name.should eq "miniTicker"
      stream.symbol.should eq "BNBBTC"
      stream.data.should be_a Binance::Responses::Websocket::MiniTicker
      stream.mini_ticker.symbol.should eq "BNBBTC"
      stream.mini_ticker.open_price.should eq 0.001
      stream.mini_ticker.last_price.should eq 0.0025
    end
  end

  context "trade" do
    trade_json = <<-JSON
      {
        "stream":"bnbbtc@trade",
        "data":{
          "e": "trade",
          "E": 1598127580715,
          "s": "BNBBTC",
          "t": 12345,
          "p": "0.001",
          "q": "100",
          "b": 88,
          "a": 50,
          "T": 1598127580715,
          "m": true,
          "M": true
        }
      }
    JSON

    it "parses" do
      stream = Binance::Responses::Websocket::Stream.from_json(trade_json)

      stream.stream.should eq "bnbbtc@trade"
      stream.name.should eq "trade"
      stream.symbol.should eq "BNBBTC"
      stream.data.should be_a Binance::Responses::Websocket::Trade
      stream.trade.symbol.should eq "BNBBTC"
      stream.trade.price.should eq 0.001
      stream.trade.quote_quantity.should eq 100.0
    end
  end

  context "book_ticker" do
    trade_json = <<-JSON
      {
        "stream":"bnbusdt@bookTicker",
        "data":  {
          "u":400900217,
          "s":"BNBUSDT",
          "b":"25.35190000",
          "B":"31.21000000",
          "a":"25.36520000",
          "A":"40.66000000"
        }
      }
    JSON

    it "parses" do
      stream = Binance::Responses::Websocket::Stream.from_json(trade_json)

      stream.stream.should eq "bnbusdt@bookTicker"
      stream.name.should eq "bookTicker"
      stream.symbol.should eq "BNBUSDT"
      stream.data.should be_a Binance::Responses::Websocket::BookTicker
      stream.book_ticker.symbol.should eq "BNBUSDT"
      stream.book_ticker.bid_price.should eq 25.3519
      stream.book_ticker.bid_quantity.should eq 31.21
      stream.book_ticker.ask_price.should eq 25.3652
      stream.book_ticker.ask_quantity.should eq 40.66
    end
  end

  context "kline" do
    kline_json = <<-JSON
      {
        "stream":"bnbbtc@kline",
        "data": {
          "e": "kline",
          "E": 123456789,
          "s": "BNBBTC",
          "k": {
            "t": 123400000,
            "T": 123460000,
            "s": "BNBBTC",
            "i": "1m",
            "f": 100,
            "L": 200,
            "o": "0.0010",
            "c": "0.0020",
            "h": "0.0025",
            "l": "0.0015",
            "v": "1000",
            "n": 100,
            "x": true,
            "q": "1.0000",
            "V": "500",
            "Q": "0.500",
            "B": "123456"
          }
        }
      }
    JSON

    it "parses" do
      stream = Binance::Responses::Websocket::Stream.from_json(kline_json)

      stream.stream.should eq "bnbbtc@kline"
      stream.name.should eq "kline"
      stream.symbol.should eq "BNBBTC"
      stream.data.should be_a Binance::Responses::Websocket::Kline
      stream.kline.symbol.should eq "BNBBTC"
      stream.kline.candle.symbol.should eq "BNBBTC"
      stream.kline.candle.interval.should eq "1m"
      stream.kline.candle.first_trade_id.should eq 100
      stream.kline.candle.last_trade_id.should eq 200
      stream.kline.candle.trades.should eq 100
      stream.kline.candle.open_price.should eq 0.001
      stream.kline.candle.high_price.should eq 0.0025
      stream.kline.candle.low_price.should eq 0.0015
      stream.kline.candle.close_price.should eq 0.002
      stream.kline.candle.base_volume.should eq 1000
      stream.kline.candle.closed.should eq true
      stream.kline.candle.quote_volume.should eq 1.0
      stream.kline.candle.taker_base_volume.should eq 500
      stream.kline.candle.taker_quote_volume.should eq 0.5
    end
  end
end

