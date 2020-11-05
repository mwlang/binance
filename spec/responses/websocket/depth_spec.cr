require "../../spec_helper"

json_object = <<-JSON
  {
    "e": "depthUpdate",
    "E": 123456789,
    "s": "BNBBTC",
    "U": 157,
    "u": 160,
    "b": [
      [
        "0.0024",
        "10"
      ]
    ],
    "a": [
      [
        "0.0026",
        "100"
      ]
    ]
  }
JSON

describe Binance::Responses::Websocket::Depth do
  it "parses object" do
    depth = Binance::Responses::Websocket::Depth.from_json(json_object)
    depth.symbol.should eq "BNBBTC"

    depth.first_update_id.should eq 157
    depth.last_update_id.should eq 160
    depth.bids.map(&.price).should eq [0.0024]
    depth.bids.map(&.quantity).should eq [10.0]
    depth.asks.map(&.price).should eq [0.0026]
    depth.asks.map(&.quantity).should eq [100.0]
  end
end
