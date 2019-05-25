require "../../spec_helper"

json = <<-JSON 
  {
    "filterType": "LOT_SIZE",
    "minQty": "0.00100000",
    "maxQty": "100000.00000000",
    "stepSize": "0.0100000"
  }
JSON

describe Binance::Responses::LotSizeFilter do
  it "parses price filter" do
    filter = Binance::Responses::LotSizeFilter.from_json(json)
    filter.min_quantity.should eq 0.001
    filter.max_quantity.should eq 100000.0
    filter.step_size.should eq 0.01
  end
end

