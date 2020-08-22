require "../../spec_helper"

json_array = <<-JSON
  [
    {
      "symbol": "LTCBTC",
      "price": "4.00000200"
    },
    {
      "symbol": "ETHBTC",
      "price": "0.07946600"
    }
  ]
JSON

json_object = <<-JSON
  {
    "symbol": "LTCBTC",
    "price": "4.00000200"
  }
JSON

describe Binance::Responses::PriceResponse do
  it "parses array" do
    response = Binance::Responses::PriceResponse.from_json(json_array)
    response.tickers.size.should eq 2
    response.tickers.map(&.symbol).should eq ["LTCBTC", "ETHBTC"]
    response.tickers.map(&.price).should eq [4.000002, 0.079466]
  end

  it "parses object" do
    response = Binance::Responses::PriceResponse.from_json(json_object)
    response.tickers.size.should eq 1
    response.tickers.map(&.symbol).should eq ["LTCBTC"]
    response.tickers.map(&.price).should eq [4.000002]
  end
end
