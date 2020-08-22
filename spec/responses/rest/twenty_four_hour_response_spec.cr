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
  }
JSON

describe Binance::Responses::TwentyFourHourResponse do
  it "parses array" do
    response = Binance::Responses::TwentyFourHourResponse.from_json(json_array)
    response.tickers.map(&.symbol).should eq ["BNBBTC", "BTCUSDT"]
    response.tickers.size.should eq 2
    ticker = response.tickers[0]
    ticker.price_change.should eq -94.999998
    ticker.price_change_percent.should eq -95.96
    ticker.weighted_average_price.should eq 0.29628482
    ticker.prev_close_price.should eq 0.10002
    ticker.last_price.should eq 4.000002
    ticker.last_quantity.should eq 200
    ticker.bid_price.should eq 4.0
    ticker.ask_price.should eq 4.000002
    ticker.open_price.should eq 99.0
    ticker.high_price.should eq 100
    ticker.low_price.should eq 0.10
    ticker.base_volume.should eq 8913.3
    ticker.quote_volume.should eq 15.3
    ticker.open_time.to_s.should eq "2017-07-11 14:31:39 UTC"
    ticker.close_time.to_s.should eq "2017-07-12 14:31:39 UTC"
    ticker.first_trade_id.should eq 28385
    ticker.last_trade_id.should eq 28460
    ticker.trades.should eq 76
  end

  it "parses object" do
    response = Binance::Responses::TwentyFourHourResponse.from_json(json_object)
    response.tickers.map(&.symbol).should eq ["BNBBTC"]
    response.tickers.size.should eq 1
    ticker = response.tickers[0]
    ticker.price_change.should eq -94.999998
    ticker.price_change_percent.should eq -95.96
    ticker.weighted_average_price.should eq 0.29628482
    ticker.prev_close_price.should eq 0.10002
    ticker.last_price.should eq 4.000002
    ticker.last_quantity.should eq 200
    ticker.bid_price.should eq 4.0
    ticker.ask_price.should eq 4.000002
    ticker.open_price.should eq 99.0
    ticker.high_price.should eq 100
    ticker.low_price.should eq 0.10
    ticker.base_volume.should eq 8913.3
    ticker.quote_volume.should eq 15.3
    ticker.open_time.to_s.should eq "2017-07-11 14:31:39 UTC"
    ticker.close_time.to_s.should eq "2017-07-12 14:31:39 UTC"
    ticker.first_trade_id.should eq 28385
    ticker.last_trade_id.should eq 28460
    ticker.trades.should eq 76
  end
end
