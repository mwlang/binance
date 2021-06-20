module Binance::Responses
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
