require "./spec_helper"

client = Binance::REST.new

describe Binance do

  it "#ping" do
    client.ping.pong.should be_truthy
  end

  it "#time" do
    response = client.time
    response.should be_a Binance::Responses::TimeResponse
    response.server_time.year.should be >= Time.now.year
    response.body.should match /serverTime/
  end

  it "#exchange_info" do
    response = client.exchange_info
    response.should be_a Binance::Responses::ExchangeInfoResponse
    response.timezone.should eq "UTC"
    response.server_time.year.should be >= Time.now.year
    response.rate_limits.should be_a Array(Binance::Responses::RateLimit)
    response.exchange_filters.should be_a Array(Binance::Responses::ExchangeFilter)
  end

  it "#depth(\"BNBUSDT\", 5)" do
    response = client.depth("BNBUSDT", 5)
    response.should be_a Binance::Responses::DepthResponse
    response.bids.size.should eq 5
  end

  it "#depth(\"BNBUSDT\", 10)" do
    response = client.depth("BNBUSDT", 10)
    response.should be_a Binance::Responses::DepthResponse
    response.bids.size.should eq 10
  end

  it "#depth(\"BNBUSDT\", 2)" do
    response = client.depth("BNBUSDT", 2)
    response.should be_a Binance::Responses::DepthResponse
    response.success.should eq false
    response.bids.size.should eq 0
    response.error.should eq "Illegal characters found in parameter 'limit'; legal range is '5, 10, 20, 50, 100, 500, 1000'."
    response.error_code.should eq "-1100"
  end
end
