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
  class PriceResponse < Responses::ServerResponse
    property tickers : Array(PriceEntry) = [] of PriceEntry

    def self.from_json(json)
      pull = JSON::PullParser.new(json)
      PriceResponse.new.tap do |resp|
        if pull.kind.begin_array?
          resp.tickers = Array(PriceEntry).new(pull)
        else
          resp.tickers << PriceEntry.new(pull)
        end
      end
    end
  end
end
