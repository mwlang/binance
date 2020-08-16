require "../spec_helper"

json = <<-JSON
  [
    {
      "id": 52027722,
      "price": "0.00324060",
      "qty": "3.27000000",
      "quoteQty": "0.01059676",
      "time": 1561473127043,
      "isBuyerMaker": false,
      "isBestMatch": true
    },
    {
      "id": 52027723,
      "price": "0.00323940",
      "qty": "0.66000000",
      "quoteQty": "0.00213800",
      "time": 1561473128646,
      "isBuyerMaker": true,
      "isBestMatch": true
    },
    {
      "id": 52027724,
      "price": "0.00324000",
      "qty": "2.49000000",
      "quoteQty": "0.00806760",
      "time": 1561473131487,
      "isBuyerMaker": true,
      "isBestMatch": true
    },
    {
      "id": 52027725,
      "price": "0.00324060",
      "qty": "3.25000000",
      "quoteQty": "0.01053195",
      "time": 1561473132078,
      "isBuyerMaker": false,
      "isBestMatch": true
    },
    {
      "id": 52027726,
      "price": "0.00324060",
      "qty": "5.00000000",
      "quoteQty": "0.01620300",
      "time": 1561473132149,
      "isBuyerMaker": false,
      "isBestMatch": true
    }
  ]
JSON

describe Binance::Responses::TradesResponse do
  it "parses" do
    response = Binance::Responses::TradesResponse.from_json(json)
    response.trades.map(&.price).should eq [0.0032406, 0.0032394, 0.00324, 0.0032406, 0.0032406]
    response.trades.map(&.quantity).should eq [3.27, 0.66, 2.49, 3.25, 5.0]
    response.trades.map(&.quote_quantity).should eq [0.01059676, 0.002138, 0.0080676, 0.01053195, 0.016203]
    response.trades.map(&.time.to_s).should eq ["2019-06-25 14:32:07 UTC", "2019-06-25 14:32:08 UTC", "2019-06-25 14:32:11 UTC", "2019-06-25 14:32:12 UTC", "2019-06-25 14:32:12 UTC"]
    response.trades.map(&.is_buyer_maker).should eq [false, true, true, false, false]
    response.trades.map(&.is_best_match).should eq [true, true, true, true, true]
  end
end
