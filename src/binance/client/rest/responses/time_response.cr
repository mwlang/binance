module Binance::Responses
  # Example Server Response:
  #     {
  #       "serverTime": 1499827319559
  #     }  
  class TimeResponse < Responses::ServerResponse

    @[JSON::Field(key: "serverTime", converter: Binance::Converters::ToTime)]
    # A `Time` representation of the serverTime property
    getter server_time : ::Time = ::Time.now
  end
end