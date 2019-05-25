require "../spec_helper"

json = <<-JSON
  [
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
      },
      {
        "filterType": "UNKNOWN",
        "foo": "bar"
      }
  ]
JSON

describe Binance::Responses::ExchangeFilter do

  it "parses" do
    filters = Binance::Responses::ExchangeFilter.from_array(json)
    filters.size.should eq 8
    filters[0].should be_a Binance::Responses::PriceFilter
    filters[1].should be_a Binance::Responses::PercentPriceFilter
    filters[2].should be_a Binance::Responses::LotSizeFilter
    filters[3].should be_a Binance::Responses::MinNotionalFilter
    filters[4].should be_a Binance::Responses::IcebergPartsFilter
    filters[5].should be_a Binance::Responses::MarketLotSizeFilter
    filters[6].should be_a Binance::Responses::MaxNumAlgoOrdersFilter
  end

  it "sets filter_type" do
    filters = Binance::Responses::ExchangeFilter.from_array(json)
    filters[0].filter_type.should eq "PRICE_FILTER"
    filters[1].filter_type.should eq "PERCENT_PRICE"
  end

  it "handles unknown filters" do
    filters = Binance::Responses::ExchangeFilter.from_array(json)
    filters[7].should be_a Binance::Responses::ExchangeFilter
    filters[7].filter_type.should eq "UNKNOWN"
    filters[7].json_unmapped["foo"].should eq "bar"
  end
end

