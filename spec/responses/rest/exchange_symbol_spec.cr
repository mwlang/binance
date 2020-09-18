require "../../spec_helper"

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

module Binance::Responses
  describe ExchangeSymbol do
    it "parses" do
      symbol = ExchangeSymbol.from_json(json)
      symbol.symbol.should eq "ETHBTC"
      symbol.status.should eq "TRADING"
      symbol.base_asset.should eq "ETH"
      symbol.base_asset_precision.should eq 8
      symbol.quote_asset.should eq "BTC"
      symbol.quote_asset_precision.should eq 8
      symbol.order_types.should eq ["LIMIT", "LIMIT_MAKER", "MARKET", "STOP_LOSS_LIMIT", "TAKE_PROFIT_LIMIT"]
    end

    it "has price_filter properties" do
      symbol = ExchangeSymbol.from_json(json)
      symbol.price_filter.should be_a(PriceFilter)
      symbol.price_filter.tick_size.should eq 0.000001
      symbol.tick_size.should eq 0.000001
      symbol.min_price.should eq 0.000001
      symbol.max_price.should eq 100000.0
    end

    it "has percent_price_filter properties" do
      symbol = ExchangeSymbol.from_json(json)
      symbol.percent_price_filter.should be_a(PercentPriceFilter)
      symbol.multiplier_up.should eq 5.0
      symbol.multiplier_down.should eq 0.2
      symbol.avg_price_mins.should eq 5
    end

    it "has market_lot_size properties" do
      symbol = ExchangeSymbol.from_json(json)
      symbol.market_lot_size_filter.should be_a(MarketLotSizeFilter)
      symbol.min_quantity.should eq 0.0
      symbol.max_quantity.should eq 63100.0
      symbol.step_size.should eq 0.0
    end

    it "has min_notional_filter properties" do
      symbol = ExchangeSymbol.from_json(json)
      symbol.min_notional_filter.should be_a(MinNotionalFilter)
      symbol.min_notional.should eq 0.001
      symbol.apply_to_market.should be_true
      symbol.avg_price_mins.should eq 5
    end

    it "has max_num_algo_orders properties" do
      symbol = ExchangeSymbol.from_json(json)
      symbol.max_num_algo_orders_filter.should be_a(MaxNumAlgoOrdersFilter)
      symbol.max_num_algo_orders.should eq 5
    end

    it "has iceberg_parts properties" do
      symbol = ExchangeSymbol.from_json(json)
      symbol.iceberg_parts_filter.should be_a(IcebergPartsFilter)
      symbol.iceberg_parts_filter.limit.should eq 10
      # :limit isn't delegated -- ambiguous!
    end

    it "detects order types" do
      symbol = ExchangeSymbol.from_json(json)
      symbol.limit_orders?.should eq true
      symbol.limit_maker_orders?.should eq true
      symbol.take_profit_orders?.should eq false
    end
  end
end