require "../spec_helper"

json_array = <<-JSON
  [
    {
      "symbol": "LTCBTC",
      "bidPrice": "4.00000000",
      "bidQty": "431.00000000",
      "askPrice": "4.00000200",
      "askQty": "9.00000000"
    },
    {
      "symbol": "ETHBTC",
      "bidPrice": "0.07946700",
      "bidQty": "9.00000000",
      "askPrice": "100000.00000000",
      "askQty": "1000.00000000"
    }
  ]
JSON

json_object = <<-JSON
  {
    "symbol": "LTCBTC",
    "bidPrice": "4.00000000",
    "bidQty": "431.00000000",
    "askPrice": "4.00000200",
    "askQty": "9.00000000"
  }
JSON

describe Binance::Responses::PriceResponse do
  it "parses array" do
    response = Binance::Responses::BookTickerResponse.from_json(json_array)
    response.tickers.size.should eq 2
    response.tickers.map(&.symbol).should eq ["LTCBTC", "ETHBTC"]
    response.tickers.map(&.bid_price).should eq [4.0, 0.079467]
    response.tickers.map(&.bid_quantity).should eq [431.0, 9.0]
    response.tickers.map(&.ask_price).should eq [4.000002, 100000.0]
    response.tickers.map(&.ask_quantity).should eq [9.0, 1000.0]
  end

  it "parses object" do
    response = Binance::Responses::BookTickerResponse.from_json(json_object)
    response.tickers.size.should eq 1
    response.tickers.map(&.symbol).should eq ["LTCBTC"]
    response.tickers.map(&.bid_price).should eq [4.0]
    response.tickers.map(&.bid_quantity).should eq [431.0]
    response.tickers.map(&.ask_price).should eq [4.000002]
    response.tickers.map(&.ask_quantity).should eq [9.0]
  end
end
