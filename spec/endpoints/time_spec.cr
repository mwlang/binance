require "../spec_helper"

client = Binance::REST.new

describe Binance do
  it "#time" do
    with_vcr_cassette "public/time" do
      response = client.time
      response.should be_a Binance::Responses::TimeResponse
      response.server_time.year.should be >= 2019
      response.body.should match /serverTime/
    end
  end
end
