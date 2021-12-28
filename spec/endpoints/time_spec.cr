require "../spec_helper"

describe Binance do
  context Binance::Service::Com do
    it "#time" do
      with_vcr_cassette Binance::Service::Com, "public/time" do
        client = Binance::REST.new("", "", Binance::Service::Com)
        response = client.time
        response.should be_a Binance::Responses::TimeResponse
        response.server_time.year.should be >= 2019
        response.body.should match /serverTime/
      end
    end
  end

  context Binance::Service::Us do
    it "#time" do
      with_vcr_cassette Binance::Service::Us, "public/time" do
        client = Binance::REST.new("", "", Binance::Service::Us)
        response = client.time
        response.should be_a Binance::Responses::TimeResponse
        response.server_time.year.should be >= 2019
        response.body.should match /serverTime/
      end
    end
  end
end
