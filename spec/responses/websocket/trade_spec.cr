require "../../spec_helper"

trade_json = <<-JSON
  {
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
JSON

describe Binance::Responses::Websocket::Ticker do
  it "parses object" do
    trade = Binance::Responses::Websocket::Trade.from_json(trade_json)
    trade.symbol.should eq "BNBBTC"
    trade.trade_id.should eq 12345
    trade.price.should eq 0.001
    trade.quote_quantity.should eq 100.0
    trade.buyer_order_id.should eq 88
    trade.seller_order_id.should eq 50
    trade.is_buyer_maker.should eq  true
    trade.event_time.to_s.should eq  "2020-08-22 20:19:40 UTC"
    trade.trade_time.to_s.should eq  "2020-08-22 20:19:40 UTC"
  end
end
