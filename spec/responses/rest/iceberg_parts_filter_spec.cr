require "../../spec_helper"

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

  it "validates correctly" do
    filter = Binance::Responses::IcebergPartsFilter.from_json(json)
    filter.valid?(20).should be_false
    filter.valid?(5).should be_true
  end
end
