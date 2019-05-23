require "../../spec_helper"

describe Binance::Responses::IcebergPartsFilter do
  let(json) do
    <<-JSON 
      {
        "filterType":"ICEBERG_PARTS",
        "limit":10
      }
    JSON
  end

  let(filter) { described_class.from_json(json) }

  it "parses price filter" do
    expect(filter.limit).to eq 10
  end
end

