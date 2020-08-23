require "json"
require "spec"

ticker_json = <<-JSON
  {
    "stream":"btcusdt@ticker",
    "data":{
      "e":"24hrTicker",
      "E":1598127580715,
      "s":"BTCUSDT",
      "p":"-115.32000000",
      "P":"-0.986",
      "w":"11539.47825399",
      "x":"11692.98000000",
      "c":"11577.55000000",
      "Q":"0.08326000",
      "b":"11577.55000000",
      "B":"2.34161000",
      "a":"11577.56000000",
      "A":"1.93661500",
      "o":"11692.87000000",
      "h":"11709.10000000",
      "l":"11376.81000000",
      "v":"50129.48441400",
      "q":"578468095.27887401",
      "O":1598041180596,
      "C":1598127580596,
      "F":391750555,
      "L":392664752,
      "n":914198
    }
  }
JSON

class Stream
  getter stream : String
  getter symbol : String
  getter name : String
  getter data : Data

  def initialize(stream : String, symbol : String, name : String, data : Data)
    @stream = stream
    @symbol = symbol
    @name = name
    @data = data
  end

  def self.new(pull : JSON::PullParser)
    pull.read_begin_object
    pull.read_next
    stream = pull.read_string
    pull.read_next
    symbol, _, name = stream.partition('@')
    if name == "ticker"
      data = Ticker.new(pull)
    else
      data = Data.new(pull)
    end
    new(stream, symbol, name, data)
  end

end

module ToTime
  def self.from_json(pull : JSON::PullParser)
    value = pull.read_int
    t = Time.unix_ms(value)
    t.year <= 2015 ? Time.unix(value) : t
  end
end

class Data
  include JSON::Serializable
  include JSON::Serializable::Unmapped

  @[JSON::Field(key: "e")]
  getter event : String = ""
end

class Ticker < Data
  @[JSON::Field(key: "E", converter: ToTime)]
  getter event_time : Time = Time.utc

  @[JSON::Field(key: "s")]
  getter symbol : String = ""
end

describe Stream do
  it "parses" do
    stream = Stream.from_json(ticker_json)
    stream.should be_a Stream
    stream.stream.should eq "btcusdt@ticker"
    stream.name.should eq "ticker"
    stream.data.should be_a Ticker
  end
end