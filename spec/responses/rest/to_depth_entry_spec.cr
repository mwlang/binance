require "../../spec_helper"

json = <<-JSON
  [
    ["4.00000000", "431.00000000"]
  ]
JSON

puller = JSON::PullParser.new(json)

describe Binance::Converters::ToDepthEntry do
  it "parses price filter" do
    response = Binance::Converters::ToDepthEntry.from_json(puller)
    response.should be_a Array(Binance::Responses::DepthEntry)
  end
end
