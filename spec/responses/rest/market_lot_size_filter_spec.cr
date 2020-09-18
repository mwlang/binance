require "../../spec_helper"

json = <<-JSON
  {
    "filterType":"MARKET_LOT_SIZE",
    "minQty":"0.00000000",
    "maxQty":"63100.00000000",
    "stepSize":"0.00000000"
  }
JSON

json2 = <<-JSON
  {
    "filterType":"MARKET_LOT_SIZE",
    "minQty":"0.00000000",
    "maxQty":"63100.00000000",
    "stepSize":"0.01000000"
  }
JSON

describe Binance::Responses::LotSizeFilter do
  it "parses price filter" do
    filter = Binance::Responses::LotSizeFilter.from_json(json)
    filter.min_quantity.should eq 0.0
    filter.max_quantity.should eq 63100.0
    filter.step_size.should eq 0.0
  end

  it "validates filter correctly" do
    filter = Binance::Responses::LotSizeFilter.from_json(json)
    filter.valid?(0.0).should be_true
    filter.valid?(0.000001).should be_true
    filter.validate(0.0019000001).should be_empty
    filter.validate(0.0019).should be_empty
    filter.validate(0.19).should be_empty
    filter.validate(0.01).should be_empty
    filter.valid?(10.0).should be_true
    filter.valid?(63100.0 - 0.01).should be_true
    filter.valid?(63100.0).should be_false
  end

  it "validates filter correctly" do
    filter = Binance::Responses::LotSizeFilter.from_json(json2)
    filter.valid?(0.0).should be_true
    filter.valid?(0.01).should be_true
    filter.validate(0.0019000001).should eq ["0.0019000001 is an invalid step_size 0.01"]
    filter.validate(0.19).should be_empty
    filter.validate(0.01).should be_empty
    filter.valid?(10.0).should be_true
    filter.valid?(63100.0 - 0.01).should be_true
    filter.valid?(63100.0).should be_false
  end
end
