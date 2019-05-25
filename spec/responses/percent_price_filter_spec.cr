require "../../spec_helper"

json = <<-JSON
  {
    "filterType": "PERCENT_PRICE",
    "multiplierUp": "1.3000",
    "multiplierDown": "0.7000",
    "avgPriceMins": 5
  }
JSON

describe Binance::Responses::PercentPriceFilter do

  it "parses price filter" do
    filter = Binance::Responses::PercentPriceFilter.from_json(json)
    filter.multiplier_up.should eq 1.3
    filter.multiplier_down.should eq 0.7
    filter.avg_price_mins.should eq 5
  end
end

