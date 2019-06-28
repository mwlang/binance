require "../spec_helper"

client = Binance::REST.new

describe Binance do

  it "#historical_trades(\"BNBUSDT\", 5)" do
    with_vcr_cassette "signed/historical_trades_5" do
      response = client.historical_trades("BNBUSDT", 5)
      response.should be_a Binance::Responses::TradesResponse
      response.trades.size.should eq 5
    end
  end

end
