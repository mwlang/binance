require "../spec_helper"

describe Binance do
  context Binance::Service::Com do
    it "#ping" do
      with_vcr_cassette Binance::Service::Com, "public/ping_success" do
        client = Binance::REST.new("", "", Binance::Service::Com)
        client.ping.pong.should be_truthy
      end
    end
  end
  context Binance::Service::Us do
    it "#ping" do
      with_vcr_cassette Binance::Service::Us, "public/ping_success" do
        client = Binance::REST.new("", "", Binance::Service::Us)
        client.ping.pong.should be_truthy
      end
    end
  end
end
