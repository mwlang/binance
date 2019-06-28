require "../spec_helper"

json = <<-JSON 
  {
    "filterType":"MIN_NOTIONAL",
    "minNotional":"0.00100000",
    "applyToMarket":true,
    "avgPriceMins":5
  }
JSON

describe Binance::Responses::MinNotionalFilter do

  it "parses" do
    filter = Binance::Responses::MinNotionalFilter.from_json(json)
    filter.min_notional.should eq 0.001
    filter.apply_to_market.should eq true
    filter.avg_price_mins.should eq 5
  end
end

