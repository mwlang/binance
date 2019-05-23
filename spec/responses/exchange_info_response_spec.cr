require "../spec_helper"

describe Binance::Responses::ExchangeInfoResponse do
  let(json) do
    <<-JSON 
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
  end

  let(filter) { described_class.from_json(json) }

  it "parses" do
    expect(filter.timezone).to eq "UTC"
    expect(filter.server_time.to_s).to eq "2017-10-22 00:19:44 UTC"
    # expect(filter.rate_limits.size).to eq 1
    # expect(filter.symbols.size).to eq 1
    # expect(filter.symbols[0].symbol).to eq "ETHBTC"
  end
end

