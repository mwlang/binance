require "../spec_helper"

client = Binance::REST.new

describe Binance do

  it "#twenty_four_hour(\"BNBUSDT\")" do
    with_vcr_cassette "public/twenty_four_hour" do
      response = client.twenty_four_hour("BNBUSDT")
      response.should be_a Binance::Responses::TwentyFourHourResponse
      response.tickers.size.should eq 1
      response.tickers[0].symbol.should eq "BNBUSDT"
    end
  end

  it "#twenty_four_hour" do
    with_vcr_cassette "public/twenty_four_hour_all" do
      response = client.twenty_four_hour
      response.should be_a Binance::Responses::TwentyFourHourResponse
      response.success.should eq true
      response.tickers.size.should eq 554
      response.tickers[0].symbol.should eq "ETHBTC"
      response.tickers[0].open_price.should eq 0.025671
    end
  end
end
