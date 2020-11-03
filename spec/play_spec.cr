require "spec"
require "json"

json = <<-JSON
  [
    {
      "id": 52027722,
      "price": "0.00324060",
      "qty": "3.27000000"
    },
    {
      "id": 52027723,
      "price": "0.00323940",
      "qty": "0.66000000"
    }
  ]
JSON

module ToFloat
  def self.from_json(pull : JSON::PullParser)
    pull.read_string.to_f
  end
end

class TradeEntry
  include JSON::Serializable

  @[JSON::Field(key: "id")]
  getter trade_id : Int64

  @[JSON::Field(key: "price", converter: ToFloat)]
  getter price : Float64

  @[JSON::Field(key: "qty", converter: ToFloat)]
  getter quantity : Float64
end

class TradesResponse
  getter trades : Array(TradeEntry) = [] of TradeEntry

  def initialize(pull : JSON::PullParser)
    @trades = Array(TradeEntry).new(pull)
  end

  def self.from_json(json)
    TradesResponse.new(JSON::PullParser.new(json))
  end
end

describe TradesResponse do
  it "parses" do
    response = TradesResponse.from_json(json)
    response.trades.map(&.price).should eq [0.0032406, 0.0032394]
    response.trades.map(&.quantity).should eq [3.27, 0.66]
  end
end
