require "../spec_helper"

client = Binance::REST.new

describe Binance do
  it "#depth(\"BTCUSDT\", 100)" do
    with_vcr_cassette "public/depth_100" do
      response = client.depth("BTCUSDT", 100)
      response.should be_a Binance::Responses::DepthResponse
      response.success.should eq true
      response.bids.size.should eq 100
      response.asks.size.should eq 100
    end
  end

  it "#depth(\"BNBUSDT\", 5)" do
    with_vcr_cassette "public/depth_5" do
      response = client.depth("BNBUSDT", 5)
      response.should be_a Binance::Responses::DepthResponse
      response.bids.size.should eq 5
      response.asks.size.should eq 5
      response.bids.map(&.price).should eq [26.946, 26.9458, 26.9453, 26.9424, 26.9416]
      response.asks.map(&.price).should eq [26.95, 26.9514, 26.9516, 26.9524, 26.9525]
    end
  end

  it "#depth(\"BNBUSDT\", 10)" do
    with_vcr_cassette "public/depth_10" do
      response = client.depth("BNBUSDT", 10)
      response.should be_a Binance::Responses::DepthResponse
      response.bids.size.should eq 10
      response.asks.size.should eq 10
    end
  end

  it "#depth(\"BNBUSDT\", 2)" do
    with_vcr_cassette "public/depth_2" do
      response = client.depth("BNBUSDT", 2)
      response.should be_a Binance::Responses::DepthResponse
      response.success.should eq false
      response.bids.size.should eq 0
      response.error_message.should eq "Illegal characters found in parameter 'limit'; legal range is '5, 10, 20, 50, 100, 500, 1000, 5000'."
      response.error_code.should eq -1100
    end
  end
end
