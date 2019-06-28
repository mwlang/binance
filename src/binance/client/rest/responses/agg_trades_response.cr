module Binance::Responses

  # Typical Server Response:
  #     [
  #       {
  #         "a": 44410315,
  #         "p": "0.00307970",
  #         "q": "3.81000000",
  #         "f": 52078196,
  #         "l": 52078196,
  #         "T": 1561505178803,
  #         "m": true,
  #         "M": true
  #       },
  #       {
  #         "a": 44410316,
  #         "p": "0.00308000",
  #         "q": "0.10000000",
  #         "f": 52078197,
  #         "l": 52078197,
  #         "T": 1561505179424,
  #         "m": false,
  #         "M": true
  #       }
  #     ]
  class AggTradesResponse < ServerResponse
    property trades : Array(AggTradeEntry) = [] of AggTradeEntry

    def self.from_json(json)
      AggTradesResponse.new.tap do |resp|
        resp.trades = Array(AggTradeEntry).new(JSON::PullParser.new(json))
      end
    end

  end
end