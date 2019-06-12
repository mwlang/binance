require "./spec_helper"

client = Binance::REST.new

describe Binance do

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
