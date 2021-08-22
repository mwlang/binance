require "../spec_helper"

client = Binance::REST.new

describe Binance do
  context Binance::Service::Com do
    it "#twenty_four_hour(\"BNBUSDT\")" do
      client = Binance::REST.new("", "", Binance::Service::Com)
      with_vcr_cassette Binance::Service::Com, "public/twenty_four_hour" do
        response = client.twenty_four_hour("BNBUSDT")
        response.should be_a Binance::Responses::TwentyFourHourResponse
        response.tickers.size.should eq 1
        response.tickers[0].symbol.should eq "BNBUSDT"
      end
    end

    it "#twenty_four_hour" do
      client = Binance::REST.new("", "", Binance::Service::Com)
      with_vcr_cassette Binance::Service::Com, "public/twenty_four_hour_all" do
        response = client.twenty_four_hour
        response.should be_a Binance::Responses::TwentyFourHourResponse
        response.success.should eq true
        response.tickers.size.should eq 554
        response.tickers[0].symbol.should eq "ETHBTC"
        response.tickers[0].open_price.should eq 0.025671
      end
    end
  end

  context Binance::Service::Us do
    it "#twenty_four_hour(\"BNBUSDT\")" do
      client = Binance::REST.new("", "", Binance::Service::Us)
      with_vcr_cassette Binance::Service::Us, "public/twenty_four_hour" do
        response = client.twenty_four_hour("BNBUSDT")
        response.should be_a Binance::Responses::TwentyFourHourResponse
        response.tickers.size.should eq 1
        response.tickers[0].symbol.should eq "BNBUSDT"
      end
    end

    it "#twenty_four_hour" do
      client = Binance::REST.new("", "", Binance::Service::Us)
      with_vcr_cassette Binance::Service::Us, "public/twenty_four_hour_all" do
        response = client.twenty_four_hour
        response.should be_a Binance::Responses::TwentyFourHourResponse
        response.success.should eq true
        response.tickers.size.should eq 117
        response.tickers[0].symbol.should eq "BTCUSD"
        response.tickers[0].open_price.should eq 48733.5
      end
    end
  end
end