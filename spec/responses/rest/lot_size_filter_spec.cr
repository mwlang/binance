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

  it "validates filter correctly" do
    filter = Binance::Responses::LotSizeFilter.from_json(json)
    filter.valid?(0.0).should be_false
    filter.valid?(0.000001).should be_false
    filter.validate(0.0019000001).should eq ["0.0019000001 is an invalid step_size 0.01"]
    filter.validate(0.0019).should eq ["0.0019 is an invalid step_size 0.01"]
    filter.validate(0.19).should be_empty
    filter.validate(0.01).should be_empty
    filter.valid?(10.0).should be_true
    filter.valid?(100000.0 - 0.01).should be_true
    filter.valid?(100000.0).should be_false
    filter.valid?(100001.0).should be_false
  end
end
