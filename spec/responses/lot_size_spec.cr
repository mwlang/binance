require "../../spec_helper"

describe Binance::Responses::LotSizeFilter do
  let(json) do
    <<-JSON 
    {
      "filterType": "LOT_SIZE",
      "minQty": "0.00100000",
      "maxQty": "100000.00000000",
      "stepSize": "0.0100000"
    }
    JSON
  end

  let(filter) { described_class.from_json(json) }

  it "parses price filter" do
    expect(filter.min_quantity).to eq 0.001
    expect(filter.max_quantity).to eq 100000.0
    expect(filter.step_size).to eq 0.01
  end
end

