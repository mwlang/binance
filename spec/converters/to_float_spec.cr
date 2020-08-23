require "../spec_helper"

class ToFloatTest
  include JSON::Serializable

  @[JSON::Field(key: "id")]
  getter trade_id : Int32

  @[JSON::Field(key: "price", converter: Binance::Converters::ToFloat)]
  getter price : Float64

  @[JSON::Field(key: "qty", converter: Binance::Converters::ToFloat)]
  getter quantity : Float64
end


json = <<-JSON
  {
    "id": 12345,
    "price": "105.52",
    "qty": 250.0
  }
JSON

describe Binance::Converters::ToFloat do
  it "parses" do
    response = ToFloatTest.from_json(json)
    response.trade_id.should eq 12345
    response.price.should eq 105.52
    response.quantity.should eq 250.0
  end

  it "serializes" do
    response = ToFloatTest.from_json(json)
    response.to_json.should eq %{{"id":12345,"price":105.52,"qty":250.0}}
  end
end