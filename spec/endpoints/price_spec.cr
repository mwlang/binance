require "../spec_helper"

client = Binance::REST.new

describe Binance do
  it "#price(\"BNBUSDT\")" do
    with_vcr_cassette "public/price" do
      response = client.price("BNBUSDT")
      response.should be_a Binance::Responses::PriceResponse
      response.tickers.size.should eq 1
      response.tickers[0].symbol.should eq "BNBUSDT"
      response.tickers[0].price.should eq 32.5001
    end
  end

  it "#price" do
    with_vcr_cassette "public/price_all" do
      response = client.price
      response.should be_a Binance::Responses::PriceResponse
      response.success.should eq true
      response.tickers.size.should eq 554
      response.tickers[0].symbol.should eq "ETHBTC"
      response.tickers[0].price.should eq 0.026697
    end
  end
end
