require "../../spec_helper"

trade_json = <<-JSON
  {
    "e": "aggTrade",
    "E": 1598127580715,
    "s": "BNBBTC",
    "a": 12345,
    "p": "0.001",
    "q": "100",
    "f": 100,
    "l": 105,
    "T": 1598127580715,
    "m": true,
    "M": true
  }
JSON

describe Binance::Responses::Websocket::Ticker do
  it "parses object" do
    trade = Binance::Responses::Websocket::AggregateTrade.from_json(trade_json)
    trade.symbol.should eq "BNBBTC"
    trade.trade_id.should eq 12345
    trade.price.should eq 0.001
    trade.quote_quantity.should eq 100.0
    trade.first_trade_id.should eq 100
    trade.last_trade_id.should eq 105
    trade.is_buyer_maker.should eq  true
    trade.event_time.to_s.should eq  "2020-08-22 20:19:40 UTC"
    trade.trade_time.to_s.should eq  "2020-08-22 20:19:40 UTC"
  end
end
