module Binance::Responses::Websocket
  class Data
    include JSON::Serializable
    include JSON::Serializable::Unmapped

    @[JSON::Field(key: "e")]
    getter event_type : String = ""

    @[JSON::Field(key: "E", converter: Binance::Converters::ToTime)]
    getter event_time : Time = Time.utc

    @[JSON::Field(key: "s")]
    getter symbol : String = ""

  end
end
