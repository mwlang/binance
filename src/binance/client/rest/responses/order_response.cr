module Binance::Responses
  # Typical Server Response:
  #     {
  #       "symbol": "LTCBTC",
  #       "price": "4.00000200"
  #     }
  #
  # OR
  #
  #     [
  #       {
  #         "symbol": "LTCBTC",
  #         "price": "4.00000200"
  #       },
  #       {
  #         "symbol": "ETHBTC",
  #         "price": "0.07946600"
  #       }
  #     ]
  class OrderResponse < Responses::ServerResponse
    property orders : Array(OrderEntry) = [] of OrderEntry

    def self.from_json(json)
      pull = JSON::PullParser.new(json)
      OrderResponse.new.tap do |resp|
        if pull.kind == :begin_array
          resp.orders = Array(OrderEntry).new(pull)
        else
          resp.orders << OrderEntry.new(pull)
        end
      end
    end

  end
end