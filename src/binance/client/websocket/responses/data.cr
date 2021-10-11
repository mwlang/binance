module Binance::Responses::Websocket
  class Data
    include JSON::Serializable
    include JSON::Serializable::Unmapped

    @[JSON::Field(key: "e")]
    getter event_type : String = ""

    @[JSON::Field(key: "E", converter: Binance::Converters::ToTime)]
    getter event_time : Time = Time.utc

    @[JSON::Field(key: "s")]
    property symbol : String = ""

    def to_time(value : Int32)
      t = Time.unix_ms(value)
      t.year <= 2015 ? Time.unix(value) : t
    end
  end
end
