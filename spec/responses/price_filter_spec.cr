require "../../spec_helper"

describe Binance::Responses::PriceFilter do
  let(json) do
    <<-JSON 
    {
      "filterType": "PRICE_FILTER",
      "minPrice": "0.00000100",
      "maxPrice": "100000.00000000",
      "tickSize": "0.000100"
    }
  JSON
  end

  let(filter) { described_class.from_json(json) }

  it "parses" do
    expect(filter.min_price).to eq 0.000001
    expect(filter.max_price).to eq 100000.0
    expect(filter.tick_size).to eq 0.0001
  end
end

