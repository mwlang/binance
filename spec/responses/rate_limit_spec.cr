require "../../spec_helper"

describe Binance::Responses::RateLimit do

  let(filter) { described_class.from_json(json) }

  describe "REQUEST WEIGHT" do
    let(json) do
      <<-JSON 
      {
        "rateLimitType": "REQUEST_WEIGHT",
        "interval": "MINUTE",
        "intervalNum": 1,
        "limit": 1200
      }
     JSON
    end

    it "parses" do
      expect(filter.rate_limit_type).to eq "REQUEST_WEIGHT"
      expect(filter.interval).to eq "MINUTE"
      expect(filter.interval_number).to eq 1
      expect(filter.limit).to eq 1200
    end
  end

  describe "ORDERS" do
    let(json) do
      <<-JSON 
      {
        "rateLimitType": "ORDERS",
        "interval": "SECOND",
        "intervalNum": 1,
        "limit": 10
      }
      JSON
    end

    it "parses" do
      expect(filter.rate_limit_type).to eq "ORDERS"
      expect(filter.interval).to eq "SECOND"
      expect(filter.interval_number).to eq 1
      expect(filter.limit).to eq 10
    end
  end

  describe "RAW_REQUESTS" do
    let(json) do
      <<-JSON 
      {
        "rateLimitType": "RAW_REQUESTS",
        "interval": "MINUTE",
        "intervalNum": 5,
        "limit": 5000
      }
      JSON
    end

    it "parses" do
      expect(filter.rate_limit_type).to eq "RAW_REQUESTS"
      expect(filter.interval).to eq "MINUTE"
      expect(filter.interval_number).to eq 5
      expect(filter.limit).to eq 5000
    end
  end
end