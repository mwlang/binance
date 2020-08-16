require "../spec_helper"

json = <<-JSON
  {
    "price": "4000.00000000",
    "qty": "1.00000000",
    "commission": "4.00000000",
    "commissionAsset": "USDT"
  }
JSON

describe Binance::Responses::OrderFill do
  it "parses" do
    puller = JSON::PullParser.new(json)
    fill = Binance::Responses::OrderFill.new(puller)
    fill.price.should eq 4000.0
    fill.quantity.should eq 1.0
    fill.commission.should eq 4.0
    fill.commission_asset.should eq "USDT"
  end
end
