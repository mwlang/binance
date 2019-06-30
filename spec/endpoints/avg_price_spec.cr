require "../spec_helper"

client = Binance::REST.new

describe Binance do

  it "#avg_price(\"BNBUSDT\")" do
    with_vcr_cassette "public/avg_price_valid" do
      response = client.avg_price("BNBUSDT")
      response.should be_a Binance::Responses::AvgPriceResponse
      response.minutes.should eq 5
      response.price.should eq 35.48046547
    end
  end

  it "#avg_price(\"BOGUS\")" do
    with_vcr_cassette "public/avg_price_bogus" do
      response = client.avg_price("BOGUS")
      response.should be_a Binance::Responses::AvgPriceResponse
      response.success.should eq false
      response.minutes.should eq 0
      response.price.should eq 0.0
      response.error_message.should eq "Invalid symbol."
      response.error_code.should eq -1121
    end
  end
end
