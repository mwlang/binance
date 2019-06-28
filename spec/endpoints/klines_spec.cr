require "../spec_helper"

client = Binance::REST.new

describe Binance do

  it "#klines(\"BNBUSDT\", \"1h\", 5)" do
    with_vcr_cassette "public/klines_1h_5" do
      response = client.klines("BNBUSDT", "1h", 5)
      response.should be_a Binance::Responses::KlinesResponse
      response.klines.size.should eq 5
      response.klines.map(&.open_price).should eq [34.4949, 34.3671, 34.3842, 34.2751, 34.2592]
      response.klines.map(&.close_price).should eq [34.3887, 34.376, 34.2218, 34.2658, 34.2749]
      response.klines[0].open_time.to_s.should eq "2019-06-28 17:00:00 UTC"
      response.klines[0].close_time.to_s.should eq "2019-06-28 17:59:59 UTC"
      response.klines[4].open_time.to_s.should eq "2019-06-28 21:00:00 UTC"
      response.klines[4].close_time.to_s.should eq "2019-06-28 21:59:59 UTC"
    end
  end

  it "#klines(\"BOGUS\", 2)" do
    with_vcr_cassette "public/klines_bogus_2" do
      response = client.klines("BOGUS", "1h", 2)
      response.should be_a Binance::Responses::KlinesResponse
      response.success.should eq false
      response.klines.size.should eq 0
      response.error_message.should eq "Invalid symbol."
      response.error_code.should eq -1121
    end
  end
end
