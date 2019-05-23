require "../../spec_helper"

describe Binance::Responses::MinNotionalFilter do
  let(json) do
    <<-JSON 
    {
      "filterType":"MIN_NOTIONAL",
      "minNotional":"0.00100000",
      "applyToMarket":true,
      "avgPriceMins":5
    }
    JSON
  end

  let(filter) { described_class.from_json(json) }

  it "parses" do
    expect(filter.min_notional).to eq 0.001
    expect(filter.apply_to_market).to eq true
    expect(filter.avg_price_mins).to eq 5
  end
end

