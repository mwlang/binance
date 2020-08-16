require "../spec_helper"

client = Binance::REST.new

describe Binance do
  it "#trades(\"BNBUSDT\", 5)" do
    with_vcr_cassette "public/trades_5" do
      response = client.trades("BNBUSDT", 5)
      response.should be_a Binance::Responses::TradesResponse
      response.trades.size.should eq 5
    end
  end

  it "#trades(\"BOGUS\", 2)" do
    with_vcr_cassette "public/trades_2" do
      response = client.trades("BOGUS", 7)
      response.should be_a Binance::Responses::TradesResponse
      response.success.should eq false
      response.trades.size.should eq 0
      response.error_message.should eq "Invalid symbol."
      response.error_code.should eq -1121
    end
  end
end
