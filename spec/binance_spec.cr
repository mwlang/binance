require "./spec_helper"

describe Binance do

  let(client) { Binance::REST.new }
  let(time) { client.time }
  let(exchange_info) { client.exchange_info }

  it "can ping" do
    expect(client.ping.pong).to be_truthy
  end

  it "gets time" do
    expect(time).to be_a Binance::Responses::TimeResponse
    expect(time.server_time.year).to be_gte Time.now.year
    expect(time.body).to match /serverTime/
  end

  it "exchange info" do
    expect(exchange_info). to be_a Binance::Responses::ExchangeInfoResponse
    expect(exchange_info.timezone).to eq "UTC"
    expect(exchange_info.server_time.year).to be_gte Time.now.year
    expect(exchange_info.rate_limits).to be_a Array(Binance::Responses::RateLimit)
    expect(exchange_info.exchange_filters).to be_a Array(Binance::Responses::ExchangeFilter)
  end

end
