require "../spec_helper"

describe Binance do
  context "blank API KEY" do
    it "#historical_trades(\"BNBUSDT\", 5)" do
      client = Binance::REST.new("", "", Binance::Service::Com)
      with_vcr_cassette Binance::Service::Com, "public/historical_trades_unauthorized" do
        response = client.historical_trades("BNBUSDT", 5)
        response.should be_a Binance::Responses::TradesResponse
        response.trades.size.should eq 0
        response.success.should eq false
        response.error_message.should eq "No API KEY assigned"
      end
    end
  end

  context "valid API KEY" do
    it "#historical_trades(\"BNBUSDT\", 5)" do
      client = Binance::REST.new(api_key, api_secret, Binance::Service::Com)
      with_vcr_cassette(Binance::Service::Com, "signed/historical_trades_bnbusdt_5") do
        response = client.historical_trades("BNBUSDT", 5)
        pp! response
        response.should be_a Binance::Responses::TradesResponse
        response.success.should eq true
        response.trades.size.should eq 5
        response.trades.map(&.price).should eq [32.2346, 32.2184, 32.2183, 32.2197, 32.2196]
      end
    end
  end
end
