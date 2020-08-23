require "../spec_helper"

json = <<-JSON
  [
    ["4.00000000", "431.00000000"],
    ["6.00000000", "131.00000000"]
  ]
JSON

describe Binance::Converters::ToDepthEntry do
  it "parses price filter" do
    puller = JSON::PullParser.new(json)
    response = Binance::Converters::ToDepthEntry.from_json(puller)
    response.should be_a Array(Binance::Responses::DepthEntry)
  end

  it "serializes" do
    puller = JSON::PullParser.new(json)
    response = Binance::Converters::ToDepthEntry.from_json(puller)
    response.to_json.should eq %{[["4.0","431.0"],["6.0","131.0"]]}
  end
end
