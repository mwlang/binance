require "../../spec_helper"

json = <<-JSON
    {
      "timezone": "UTC",
      "serverTime": 1508631584636,
      "rateLimits": [
        {
          "rateLimitType": "REQUEST_WEIGHT",
          "interval": "MINUTE",
          "intervalNum": 1,
          "limit": 1200
        }
      ],
      "exchangeFilters": [
      ],
      "symbols": [{
        "symbol": "ETHBTC",
        "status": "TRADING",
        "baseAsset": "ETH",
        "baseAssetPrecision": 8,
        "quoteAsset": "BTC",
        "quotePrecision": 8,
        "orderTypes": [
        ],
        "icebergAllowed": false,
        "filters": [
        ]
      }]
    }  
JSON

describe Binance::Responses::ExchangeInfoResponse do
  it "parses" do
    filter = Binance::Responses::ExchangeInfoResponse.from_json(json)
    filter.timezone.should eq "UTC"
    filter.server_time.to_s.should eq "2017-10-22 00:19:44 UTC"
    filter.rate_limits.size.should eq 1
    filter.symbols.size.should eq 1
    filter.symbols[0].symbol.should eq "ETHBTC"
  end
end
