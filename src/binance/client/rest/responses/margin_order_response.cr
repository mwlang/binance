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
  class MarginOrderResponse < Responses::ServerResponse
    property margin_orders : Array(MarginOrder) = [] of MarginOrder

    def self.from_json(json)
      pull = JSON::PullParser.new(json)
      MarginOrderResponse.new.tap do |resp|
        if pull.kind.begin_array?
          resp.margin_orders = Array(MarginOrder).new(pull)
        else
          resp.margin_orders << MarginOrder.new(pull)
        end
      end
    end
  end
end
