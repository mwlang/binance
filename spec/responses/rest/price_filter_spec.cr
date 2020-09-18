require "../../spec_helper"

json = <<-JSON
  {
    "filterType": "PRICE_FILTER",
    "minPrice": "0.00000100",
    "maxPrice": "100000.00000000",
    "tickSize": "0.000100"
  }
JSON

describe Binance::Responses::PriceFilter do
  it "parses" do
    filter = Binance::Responses::PriceFilter.from_json(json)
    filter.min_price.should eq 0.000001
    filter.max_price.should eq 100000.0
    filter.tick_size.should eq 0.0001
  end

  it "validates filter correctly" do
    filter = Binance::Responses::PriceFilter.from_json(json)
    filter.valid?(0.0).should be_false
    filter.valid?(0.000001).should be_false
    filter.validate(0.0019000001).should eq ["0.0019000001 is an invalid tick_size 0.0001"]
    filter.validate(0.001900000).should be_empty
    filter.validate(0.0001).should be_empty
    filter.valid?(10.0).should be_true
    filter.valid?(100000.0 - 0.0001).should be_true
    filter.valid?(100000.0).should be_false
    filter.valid?(100001.0).should be_false
  end
end
