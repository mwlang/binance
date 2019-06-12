require "../spec_helper"

client = Binance::REST.new

describe Binance do

  it "#ping" do
    with_vcr_cassette "public/ping_success" do
      client.ping.pong.should be_truthy
    end
  end

end
