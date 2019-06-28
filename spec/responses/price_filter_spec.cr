require "../spec_helper"

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
end

