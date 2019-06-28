require "../spec_helper"

json = <<-JSON
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

describe Binance::Responses::ExchangeSymbol do
  it "parses" do
    filter = Binance::Responses::ExchangeSymbol.from_json(json)
    filter.symbol.should eq "ETHBTC"
    filter.status.should eq "TRADING"
    filter.base_asset.should eq "ETH"
    filter.base_asset_precision.should eq 8
    filter.quote_asset.should eq "BTC"
    filter.quote_asset_precision.should eq 8
    filter.order_types.should eq ["LIMIT", "LIMIT_MAKER", "MARKET", "STOP_LOSS_LIMIT", "TAKE_PROFIT_LIMIT"]
  end

  it "detects order types" do
    filter = Binance::Responses::ExchangeSymbol.from_json(json)
    filter.limit_orders?.should eq true
    filter.limit_maker_orders?.should eq true
    filter.take_profit_orders?.should eq false
  end
end

