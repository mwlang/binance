module Binance::Responses
  # Typical Server Response:
  #     [
  #       {
  #         "symbol": "BNBBTC",
  #         "id": 28457,
  #         "orderId": 100234,
  #         "price": "4.00000100",
  #         "qty": "12.00000000",
  #         "quoteQty": "48.000012",
  #         "commission": "10.10000000",
  #         "commissionAsset": "BNB",
  #         "time": 1499865549590,
  #         "isBuyer": true,
  #         "isMaker": false,
  #         "isBestMatch": true
  #       }
  #     ]
  class MyTradesResponse < ServerResponse
    property trades : Array(MyTradeEntry) = [] of MyTradeEntry

    def self.from_json(json)
      MyTradesResponse.new.tap do |resp|
        resp.trades = Array(MyTradeEntry).new(JSON::PullParser.new(json))
      end
    end
  end
end
