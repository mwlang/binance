module Binance::Responses
  # Example Server Response:
  #     {}
  class PingResponse < Responses::ServerResponse

    @[JSON::Field(key: "pong", converter: Binance::Converters::ToPong)]
    # true if ping was successful
    getter pong : Bool = false

    # nodoc
    def after_serialization
      unless @response.nil?
        @pong = body == "{}"
      end
    end
  end
end