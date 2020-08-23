  # {
  #   "e": "24hrMiniTicker",  // Event type
  #   "E": 123456789,         // Event time
  #   "s": "BNBBTC",          // Symbol
  #   "c": "0.0025",          // Close price
  #   "o": "0.0010",          // Open price
  #   "h": "0.0025",          // High price
  #   "l": "0.0010",          // Low price
  #   "v": "10000",           // Total traded base asset volume
  #   "q": "18"               // Total traded quote asset volume
  # }
module Binance::Responses::Websocket
  class MiniTicker < Data
    include JSON::Serializable

    @[JSON::Field(key: "c", converter: Binance::Converters::ToFloat)]
    getter last_price : Float64 = 0.0

    @[JSON::Field(key: "o", converter: Binance::Converters::ToFloat)]
    getter open_price : Float64 = 0.0

    @[JSON::Field(key: "h", converter: Binance::Converters::ToFloat)]
    getter high_price : Float64 = 0.0

    @[JSON::Field(key: "l", converter: Binance::Converters::ToFloat)]
    getter low_price : Float64 = 0.0

    @[JSON::Field(key: "v", converter: Binance::Converters::ToFloat)]
    getter base_volume : Float64 = 0.0

    @[JSON::Field(key: "q", converter: Binance::Converters::ToFloat)]
    getter quote_volume : Float64 = 0.0

    def open_time
      @event_time - 24.hours - 1.second
    end

    def close_time
      @event_time
    end
  end
end
