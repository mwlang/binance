require "./spec_helper"

client = Binance::REST.new

describe Binance do

  # To run these tests, you'll need a Binance account, valid API KEY and SECRET
  # These are set in the ./spec/test.yml file.  
  # Copy ./spec/test.yml.example to ./spec/test.yml and
  # change to match your API key and secret
  context "./spec/test.yml exists" do
    it "and finds \"api_key\" entry in ./spec/test.yml" do
      api_key.should_not eq test_api_key
    end

    it "and finds \"api_secret\" entry in ./spec/test.yml" do
      api_secret.should_not eq test_api_secret
    end
    
  end

  context "HMAC" do
    signed_client = Binance::REST.new(api_key: test_api_key, secret_key: test_api_secret)
    it "#hmac" do
      data = "symbol=LTCBTC&side=BUY&type=LIMIT&timeInForce=GTC&quantity=1&price=0.1&recvWindow=5000&timestamp=1499827319559"
      signed_client.hmac(data).should eq "c8db56825ae71d6d79447849e617115f4a920fa2acdcab2b053c4b2838bd6b71"
    end
  end

  context "not stubbed" do
    it "#ping" do
      response = client.ping
      response.success.should be_falsey
      response.exception.should be_a WebMock::NetConnectNotAllowedError
      response.error_message.to_s.should start_with "Real HTTP connections are disabled"
      response.pong.should be_falsey
    end
  end

  context "stubbed" do
    it "#ping" do
      with_vcr_cassette("public/ping_success") do
        response = client.ping
        response.success.should be_truthy
        response.exception.should_not be_a WebMock::NetConnectNotAllowedError
        response.error_message.to_s.should eq ""
        response.pong.should be_truthy
      end
    end

    it "#time" do
      with_vcr_cassette("public/time_success") do
        response = client.time
        response.success.should be_truthy
        response.error_message.to_s.should eq ""
        response.server_time.year.should eq 2017
      end
    end
  end

  context "error response" do
    it "#ping" do
      with_vcr_cassette("public/ping_error") do
        response = client.ping
        response.body.should eq "{\"code\": -3121, \"msg\": \"Strange Error.\"}"
        response.error_code.should eq -3121
        response.success.should be_falsey
      end
    end
  end
end
