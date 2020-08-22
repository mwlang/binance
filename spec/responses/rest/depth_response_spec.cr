require "../../spec_helper"

json = <<-JSON
  {
    "lastUpdateId":252500077,
    "bids":[
      ["33.96240000","17.51000000"],
      ["33.96150000","2.94000000"],
      ["33.96000000","44.16000000"],
      ["33.95040000","1.88000000"],
      ["33.95020000","23.22000000"]
    ],
    "asks":[
      ["33.97870000","37.02000000"],
      ["33.97880000","2.94000000"],
      ["33.99980000","34.97000000"],
      ["34.00000000","2043.25000000"],
      ["34.00840000","23.09000000"]
    ]
  }
JSON

describe Binance::Responses::DepthResponse do
  it "parses" do
    response = Binance::Responses::DepthResponse.from_json(json)
    response.last_update_id.should eq 252500077
    response.bids.map(&.price).should eq [33.9624, 33.9615, 33.96, 33.9504, 33.9502]
    response.bids.map(&.quantity).should eq [17.51, 2.94, 44.16, 1.88, 23.22]
    response.asks.map(&.price).should eq [33.9787, 33.9788, 33.9998, 34.0, 34.0084]
    response.asks.map(&.quantity).should eq [37.02, 2.94, 34.97, 2043.25, 23.09]
  end
end
