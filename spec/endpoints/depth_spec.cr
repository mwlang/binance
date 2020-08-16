require "../spec_helper"

client = Binance::REST.new

describe Binance do
  it "#depth(\"BNBUSDT\", 5)" do
    with_vcr_cassette "public/depth_5" do
      response = client.depth("BNBUSDT", 5)
      response.should be_a Binance::Responses::DepthResponse
      response.bids.size.should eq 5
    end
  end

  it "#depth(\"BNBUSDT\", 10)" do
    with_vcr_cassette "public/depth_10" do
      response = client.depth("BNBUSDT", 10)
      response.should be_a Binance::Responses::DepthResponse
      response.bids.size.should eq 10
    end
  end

  it "#depth(\"BNBUSDT\", 2)" do
    with_vcr_cassette "public/depth_2" do
      response = client.depth("BNBUSDT", 2)
      response.should be_a Binance::Responses::DepthResponse
      response.success.should eq false
      response.bids.size.should eq 0
      response.error_message.should eq "Illegal characters found in parameter 'limit'; legal range is '5, 10, 20, 50, 100, 500, 1000'."
      response.error_code.should eq -1100
    end
  end
end
