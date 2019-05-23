require "../spec_helper"

describe Binance::Responses::ExchangeFilter do
  let(json) do
    <<-JSON 
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
  end

  let(filters) { described_class.from_array(json) }

  it "parses" do
    expect(filters.size).to eq 8
    expect(filters[0]).to be_a Binance::Responses::PriceFilter
    expect(filters[1]).to be_a Binance::Responses::PercentPriceFilter
    expect(filters[2]).to be_a Binance::Responses::LotSizeFilter
    expect(filters[3]).to be_a Binance::Responses::MinNotionalFilter
    expect(filters[4]).to be_a Binance::Responses::IcebergPartsFilter
    expect(filters[5]).to be_a Binance::Responses::MarketLotSizeFilter
    expect(filters[6]).to be_a Binance::Responses::MaxNumAlgoOrdersFilter
  end

  it "sets filter_type" do
    expect(filters[0].filter_type).to eq "PRICE_FILTER"
    expect(filters[1].filter_type).to eq "PERCENT_PRICE"
  end

  it "handles unknown filters" do
    expect(filters[7]).to be_a Binance::Responses::ExchangeFilter
    expect(filters[7].filter_type).to eq "UNKNOWN"
    expect(filters[7].json_unmapped["foo"]).to eq "bar"
  end
end

