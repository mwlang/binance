require "./spec_helper"

client = Binance::REST.new
client_time = client.time
client_exchange_info = client.exchange_info

describe Binance do

  # let(client) { Binance::REST.new }
  # let(time) { client.time }
  # let(exchange_info) { client.exchange_info }

  it "can ping" do
    client.ping.pong.should be_truthy
  end

  it "gets time" do
    client_time.should be_a Binance::Responses::TimeResponse
    client_time.server_time.year.should be >= Time.now.year
    client_time.body.should match /serverTime/
  end

  it "exchange info" do
    client_exchange_info.should be_a Binance::Responses::ExchangeInfoResponse
    client_exchange_info.timezone.should eq "UTC"
    client_exchange_info.server_time.year.should be >= Time.now.year
    client_exchange_info.rate_limits.should be_a Array(Binance::Responses::RateLimit)
    client_exchange_info.exchange_filters.should be_a Array(Binance::Responses::ExchangeFilter)
  end

end
