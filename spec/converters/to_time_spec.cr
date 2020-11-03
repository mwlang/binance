require "../spec_helper"

class ToTimeTest
  include JSON::Serializable

  @[JSON::Field(key: "id")]
  getter trade_id : Int64

  @[JSON::Field(key: "start_time", converter: Binance::Converters::ToTime)]
  getter start_time : Time

  @[JSON::Field(key: "end_time", converter: Binance::Converters::ToTime)]
  getter end_time : Time
end


json = <<-JSON
  {
    "id": 12345,
    "start_time": 1598152024,
    "end_time": 1598152024576
  }
JSON

describe Binance::Converters::ToFloat do
  it "parses" do
    response = ToTimeTest.from_json(json)
    response.trade_id.should eq 12345
    response.start_time.to_s.should eq "2020-08-23 03:07:04 UTC"
    response.end_time.to_s.should eq "2020-08-23 03:07:04 UTC"
  end

  it "serializes" do
    response = ToTimeTest.from_json(json)
    response.to_json.should eq %{{"id":12345,"start_time":1598152024,"end_time":1598152024}}
    new_response = ToTimeTest.from_json(response.to_json)
    new_response.start_time.should eq response.start_time
    new_response.end_time.should be_close response.end_time, 1.second
  end
end