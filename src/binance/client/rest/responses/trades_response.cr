module Binance::Responses
  # Typical Server Response:
  #   [
  #     {
  #       "id": 52027722,
  #       "price": "0.00324060",
  #       "qty": "3.27000000",
  #       "quoteQty": "0.01059676",
  #       "time": 1561473127043,
  #       "isBuyerMaker": false,
  #       "isBestMatch": true
  #     },
  #     {
  #       "id": 52027723,
  #       "price": "0.00323940",
  #       "qty": "0.66000000",
  #       "quoteQty": "0.00213800",
  #       "time": 1561473128646,
  #       "isBuyerMaker": true,
  #       "isBestMatch": true
  #     },
  #     {
  #       "id": 52027724,
  #       "price": "0.00324000",
  #       "qty": "2.49000000",
  #       "quoteQty": "0.00806760",
  #       "time": 1561473131487,
  #       "isBuyerMaker": true,
  #       "isBestMatch": true
  #     },
  #     {
  #       "id": 52027725,
  #       "price": "0.00324060",
  #       "qty": "3.25000000",
  #       "quoteQty": "0.01053195",
  #       "time": 1561473132078,
  #       "isBuyerMaker": false,
  #       "isBestMatch": true
  #     },
  #     {
  #       "id": 52027726,
  #       "price": "0.00324060",
  #       "qty": "5.00000000",
  #       "quoteQty": "0.01620300",
  #       "time": 1561473132149,
  #       "isBuyerMaker": false,
  #       "isBestMatch": true
  #     }
  #   ]
  class TradesResponse < ServerResponse
    property trades : Array(TradeEntry) = [] of TradeEntry

    def self.from_json(json)
      TradesResponse.new.tap do |resp|
        resp.trades = Array(TradeEntry).new(JSON::PullParser.new(json))
      end
    end
  end
end
