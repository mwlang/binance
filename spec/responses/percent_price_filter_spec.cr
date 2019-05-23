require "../../spec_helper"

describe Binance::Responses::PercentPriceFilter do
  let(json) do
    <<-JSON 
    {
      "filterType": "PERCENT_PRICE",
      "multiplierUp": "1.3000",
      "multiplierDown": "0.7000",
      "avgPriceMins": 5
    }
    JSON
  end

  let(filter) { described_class.from_json(json) }

  it "parses price filter" do
    expect(filter.multiplier_up).to eq 1.3
    expect(filter.multiplier_down).to eq 0.7
    expect(filter.avg_price_mins).to eq 5
  end
end

