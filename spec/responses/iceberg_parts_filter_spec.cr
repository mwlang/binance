require "../spec_helper"

json = <<-JSON
    {
      "filterType":"ICEBERG_PARTS",
      "limit":10
    }
JSON

describe Binance::Responses::IcebergPartsFilter do
  it "parses price filter" do
    filter = Binance::Responses::IcebergPartsFilter.from_json(json)
    filter.limit.should eq 10
  end
end
