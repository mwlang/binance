module Binance::Responses
  # Typical Server Response:
  #     {
  #       "symbol": "LTCBTC",
  #       "bidPrice": "4.00000000",
  #       "bidQty": "431.00000000",
  #       "askPrice": "4.00000200",
  #       "askQty": "9.00000000"
  #     }
  #
  # OR
  #
  #     [
  #       {
  #         "symbol": "LTCBTC",
  #         "bidPrice": "4.00000000",
  #         "bidQty": "431.00000000",
  #         "askPrice": "4.00000200",
  #         "askQty": "9.00000000"
  #       },
  #       {
  #         "symbol": "ETHBTC",
  #         "bidPrice": "0.07946700",
  #         "bidQty": "9.00000000",
  #         "askPrice": "100000.00000000",
  #         "askQty": "1000.00000000"
  #       }
  #     ]
  class BookTickerResponse < Responses::ServerResponse
    property tickers : Array(BookTickerEntry) = [] of BookTickerEntry

    def self.from_json(json)
      pull = JSON::PullParser.new(json)
      BookTickerResponse.new.tap do |resp|
        if pull.kind == :begin_array
          resp.tickers = Array(BookTickerEntry).new(pull)
        else
          resp.tickers << BookTickerEntry.new(pull)
        end
      end
    end

  end
end