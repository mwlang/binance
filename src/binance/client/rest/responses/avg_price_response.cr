module Binance::Responses
  # Example Server Response:
  #     {
  #       "mins": 5,
  #       "price": "9.35751834"
  #     }
  class AvgPriceResponse < Responses::ServerResponse

    @[JSON::Field(key: "mins")]
    getter minutes : Int32 = 0

    @[JSON::Field(key: "price", converter: Binance::Converters::ToFloat)]
    getter price : Float64 = 0.0
  end
end