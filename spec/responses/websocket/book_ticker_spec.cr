require "../../spec_helper"

json_object = <<-JSON
  {
    "u":400900217,
    "s":"BNBUSDT",
    "b":"25.35190000",
    "B":"31.21000000",
    "a":"25.36520000",
    "A":"40.66000000"
  }
JSON

describe Binance::Responses::Websocket::BookTicker do
  it "parses object" do
    ticker = Binance::Responses::Websocket::BookTicker.from_json(json_object)
    ticker.symbol.should eq "BNBUSDT"
    ticker.bid_price.should eq 25.3519
    ticker.bid_quantity.should eq 31.21
    ticker.ask_price.should eq 25.3652
    ticker.ask_quantity.should eq 40.66
  end
end
