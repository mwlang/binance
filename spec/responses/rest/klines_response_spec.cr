require "../../spec_helper"

json = <<-JSON
  [
    [
      1561752000000,
      "311.45000000",
      "312.72000000",
      "306.41000000",
      "308.34000000",
      "23053.32074000",
      1561755599999,
      "7131758.61054420",
      11779,
      "10883.24239000",
      "3365005.81376280",
      "0"
    ],
    [
      1561755600000,
      "308.38000000",
      "309.81000000",
      "307.16000000",
      "309.05000000",
      "4364.73408000",
      1561759199999,
      "1348225.07464830",
      1753,
      "2383.57852000",
      "736436.40170600",
      "0"
    ]
  ]
JSON

describe Binance::Responses::TradesResponse do
  it "parses" do
    response = Binance::Responses::KlinesResponse.from_json(json)
    response.klines.map(&.open_price).should eq [311.45, 308.38]
    response.klines.map(&.high_price).should eq [312.72, 309.81]
    response.klines.map(&.low_price).should eq [306.41, 307.16]
    response.klines.map(&.close_price).should eq [308.34, 309.05]
    response.klines.map(&.base_volume).should eq [23053.32074, 4364.73408]
    response.klines.map(&.quote_volume).should eq [7131758.6105442, 1348225.0746483]
    response.klines.map(&.open_time.to_s).should eq ["2019-06-28 20:00:00 UTC", "2019-06-28 21:00:00 UTC"]
    response.klines.map(&.close_time.to_s).should eq ["2019-06-28 20:59:59 UTC", "2019-06-28 21:59:59 UTC"]
    response.klines.map(&.trades).should eq [11779, 1753]
    response.klines.map(&.taker_base_volume).should eq [10883.24239, 2383.57852]
    response.klines.map(&.taker_quote_volume).should eq [3365005.8137628, 736436.401706]
  end
end
