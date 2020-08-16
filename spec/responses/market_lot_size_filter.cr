require "../spec_helper"

json = <<-JSON
  {
    "filterType":"MARKET_LOT_SIZE",
    "minQty":"0.00000000",
    "maxQty":"63100.00000000",
    "stepSize":"0.00000000"
  }
JSON

describe Binance::Responses::LotSizeFilter do
  it "parses price filter" do
    filter = Binance::Responses::LotSizeFilter.from_json(json)
    filter.min_quantity.should eq 0.0
    filter.max_quantity.should eq 63100.0
    filter.step_size.should eq 0.0
  end
end
