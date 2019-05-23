require "../../spec_helper"

describe Binance::Responses::LotSizeFilter do
  let(json) do
    <<-JSON 
      {
        "filterType":"MARKET_LOT_SIZE",
        "minQty":"0.00000000",
        "maxQty":"63100.00000000",
        "stepSize":"0.00000000"
      }
    JSON
  end

  let(filter) { described_class.from_json(json) }

  it "parses price filter" do
    expect(filter.min_quantity).to eq 0.0
    expect(filter.max_quantity).to eq 63100.0
    expect(filter.step_size).to eq 0.0
  end
end


