module Binance::Responses
  # Typical Server Response:
  #     [
  #       [
  #         1561503600000,
  #         "317.38000000",
  #         "318.99000000",
  #         "314.85000000",
  #         "318.26000000",
  #         "27588.88007000",
  #         1561507199999,
  #         "8748729.96605430",
  #         13223,
  #         "15529.46205000",
  #         "4924098.84933350",
  #         "0"
  #       ],
  #       [
  #         1561507200000,
  #         "318.29000000",
  #         "318.94000000",
  #         "316.51000000",
  #         "318.30000000",
  #         "10494.87765000",
  #         1561510799999,
  #         "3333687.82234600",
  #         6020,
  #         "5368.77538000",
  #         "1705477.19064240",
  #         "0"
  #       ]
  #     ]
  class KlinesResponse < ServerResponse
    property klines : Array(Kline) = [] of Kline

    def self.from_json(json)
      KlinesResponse.new.tap do |resp|
        resp.klines = Array(Kline).new(JSON::PullParser.new(json))
      end
    end
  end
end
