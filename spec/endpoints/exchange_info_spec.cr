require "../spec_helper"

client = Binance::REST.new

describe Binance do

  it "#exchange_info" do
    with_vcr_cassette "public/exchange_info" do
      response = client.exchange_info
      response.should be_a Binance::Responses::ExchangeInfoResponse
      response.timezone.should eq "UTC"
      response.server_time.year.should be >= 2019
      response.rate_limits.should be_a Array(Binance::Responses::RateLimit)
      response.exchange_filters.should be_a Array(Binance::Responses::ExchangeFilter)
    end
  end

end
