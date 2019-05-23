require "../../spec_helper"

describe Binance::Responses::ExchangeSymbol do
  let(json) do
    <<-JSON 
      {
        "symbol":"ETHBTC",
        "status":"TRADING",
        "baseAsset":"ETH",
        "baseAssetPrecision":8,
        "quoteAsset":"BTC",
        "quotePrecision":8,
        "orderTypes":[
          "LIMIT",
          "LIMIT_MAKER",
          "MARKET",
          "STOP_LOSS_LIMIT",
          "TAKE_PROFIT_LIMIT"
          ],
        "icebergAllowed":true,
        "isSpotTradingAllowed":true,
        "isMarginTradingAllowed":true,
        "filters":[
          {
            "filterType":"PRICE_FILTER",
            "minPrice":"0.00000100",
            "maxPrice":"100000.00000000",
            "tickSize":"0.00000100"
          },
          {
            "filterType":"PERCENT_PRICE",
            "multiplierUp":"5",
            "multiplierDown":"0.2",
            "avgPriceMins":5
          },
          {
            "filterType":"LOT_SIZE",
            "minQty":"0.00100000",
            "maxQty":"100000.00000000",
            "stepSize":"0.00100000"
          },
          {
            "filterType":"MIN_NOTIONAL",
            "minNotional":"0.00100000",
            "applyToMarket":true,
            "avgPriceMins":5
          },
          {
            "filterType":"ICEBERG_PARTS",
            "limit":10
          },
          {
            "filterType":"MARKET_LOT_SIZE",
            "minQty":"0.00000000",
            "maxQty":"63100.00000000",
            "stepSize":"0.00000000"
          },
          {
            "filterType":"MAX_NUM_ALGO_ORDERS",
            "maxNumAlgoOrders":5
          }
      ]}
    JSON
  end

  let(filter) { described_class.from_json(json) }

  it "parses" do
    expect(filter.symbol).to eq "ETHBTC"
    expect(filter.status).to eq "TRADING"
    expect(filter.base_asset).to eq "ETH"
    expect(filter.base_asset_precision).to eq 8
    expect(filter.quote_asset).to eq "BTC"
    expect(filter.quote_asset_precision).to eq 8
    expect(filter.order_types).to eq ["LIMIT", "LIMIT_MAKER", "MARKET", "STOP_LOSS_LIMIT", "TAKE_PROFIT_LIMIT"]
  end

  it "detects order types" do
    expect(filter.limit_orders?).to eq true
    expect(filter.limit_maker_orders?).to eq true
    expect(filter.take_profit_orders?).to eq false
  end
end

