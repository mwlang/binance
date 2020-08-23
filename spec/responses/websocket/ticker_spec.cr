require "../../spec_helper"

json_array = <<-JSON
  [
    {
      "symbol": "BNBBTC",
      "priceChange": "-94.99999800",
      "priceChangePercent": "-95.960",
      "weightedAvgPrice": "0.29628482",
      "prevClosePrice": "0.10002000",
      "lastPrice": "4.00000200",
      "lastQty": "200.00000000",
      "bidPrice": "4.00000000",
      "askPrice": "4.00000200",
      "openPrice": "99.00000000",
      "highPrice": "100.00000000",
      "lowPrice": "0.10000000",
      "volume": "8913.30000000",
      "quoteVolume": "15.30000000",
      "openTime": 1499783499040,
      "closeTime": 1499869899040,
      "firstId": 28385,
      "lastId": 28460, 
      "count": 76
    },
    {
      "symbol": "BTCUSDT",
      "priceChange": "-94.99999800",
      "priceChangePercent": "-95.960",
      "weightedAvgPrice": "0.29628482",
      "prevClosePrice": "0.10002000",
      "lastPrice": "4.00000200",
      "lastQty": "200.00000000",
      "bidPrice": "4.00000000",
      "askPrice": "4.00000200",
      "openPrice": "99.00000000",
      "highPrice": "100.00000000",
      "lowPrice": "0.10000000",
      "volume": "8913.30000000",
      "quoteVolume": "15.30000000",
      "openTime": 1499783499040,
      "closeTime": 1499869899040,
      "firstId": 28385,
      "lastId": 28460, 
      "count": 76
    }
  ]
JSON

json_object = <<-JSON
  {
    "e": "24hrTicker",
    "E": 1598127580715,
    "s": "BNBBTC",
    "p": "0.0015",
    "P": "250.00",
    "w": "0.0018",
    "x": "0.0009",
    "c": "0.0025",
    "Q": "10",
    "b": "0.0024",
    "B": "10",
    "a": "0.0026",
    "A": "100",
    "o": "0.0010",
    "h": "0.0025",
    "l": "0.0010",
    "v": "10000",
    "q": "18",
    "O": 0,
    "C": 1598127580715,
    "F": 28385,
    "L": 18150,
    "n": 18151
  }
JSON

describe Binance::Responses::Websocket::Ticker do
  it "parses object" do
    ticker = Binance::Responses::Websocket::Ticker.from_json(json_object)
    ticker.symbol.should eq "BNBBTC"
    ticker.price_change.should eq 0.0015
    ticker.price_change_percent.should eq 250.0
    ticker.weighted_average_price.should eq 0.0018
    ticker.prev_close_price.should eq 0.0009
    ticker.last_price.should eq 0.0025
    ticker.last_quantity.should eq 10
    ticker.bid_price.should eq 0.0024
    ticker.bid_quantity.should eq 10.0
    ticker.ask_price.should eq 0.0026
    ticker.ask_quantity.should eq 100.0
    ticker.open_price.should eq 0.001
    ticker.high_price.should eq 0.0025
    ticker.low_price.should eq 0.001
    ticker.base_volume.should eq 10000.0
    ticker.quote_volume.should eq 18.0
    ticker.event_time.to_s.should eq  "2020-08-22 20:19:40 UTC"
    ticker.close_time.to_s.should eq  "2020-08-22 20:19:40 UTC"
    ticker.open_time.to_s.should eq   "2020-08-21 20:19:39 UTC"
    ticker.first_trade_id.should eq 28385
    ticker.last_trade_id.should eq 18150
    ticker.trades.should eq 18151
  end
end
