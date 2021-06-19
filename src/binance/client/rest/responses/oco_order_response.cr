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
  class OcoOrderResponse < Responses::ServerResponse
    property oco_orders : Array(OcoOrder) = [] of OcoOrder

    def self.from_json(json)
      pull = JSON::PullParser.new(json)
      OcoOrderResponse.new.tap do |resp|
        if pull.kind.begin_array?
          resp.oco_orders = Array(OcoOrder).new(pull)
        else
          resp.oco_orders << OcoOrder.new(pull)
        end
      end
    end
  end
end
