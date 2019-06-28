require "../spec_helper"

describe Binance::Responses::RateLimit do

  describe "REQUEST WEIGHT" do

    it "parses" do
      json = <<-JSON 
        {
          "rateLimitType": "REQUEST_WEIGHT",
          "interval": "MINUTE",
          "intervalNum": 1,
          "limit": 1200
        }
      JSON
   
      filter = Binance::Responses::RateLimit.from_json(json)
      filter.rate_limit_type.should eq "REQUEST_WEIGHT"
      filter.interval.should eq "MINUTE"
      filter.interval_number.should eq 1
      filter.limit.should eq 1200
    end
  end

  describe "ORDERS" do

    it "parses" do
      json = <<-JSON 
        {
          "rateLimitType": "ORDERS",
          "interval": "SECOND",
          "intervalNum": 1,
          "limit": 10
        }
      JSON

      filter = Binance::Responses::RateLimit.from_json(json)
      filter.rate_limit_type.should eq "ORDERS"
      filter.interval.should eq "SECOND"
      filter.interval_number.should eq 1
      filter.limit.should eq 10
    end
  end

  describe "RAW_REQUESTS" do
  
    it "parses" do
      json = <<-JSON 
        {
          "rateLimitType": "RAW_REQUESTS",
          "interval": "MINUTE",
          "intervalNum": 5,
          "limit": 5000
        }
      JSON
  
      filter = Binance::Responses::RateLimit.from_json(json)
      filter.rate_limit_type.should eq "RAW_REQUESTS"
      filter.interval.should eq "MINUTE"
      filter.interval_number.should eq 5
      filter.limit.should eq 5000
    end
  end
end