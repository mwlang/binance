require "../spec_helper"

client = Binance::REST.new

describe Binance do
  context Binance::Service::Com do
    it "#agg_trades(\"BNBUSDT\", limit: 5)" do
      with_vcr_cassette Binance::Service::Com, "public/agg_trades_limit_5" do
        response = client.agg_trades("BNBUSDT", limit: 5)
        response.should be_a Binance::Responses::AggTradesResponse
        response.trades.size.should eq 5
        response.trades.map(&.price).should eq [36.0687, 36.0553, 36.0503, 36.0965, 36.05]
      end
    end

    it "#agg_trades(\"BNBUSDT\", 5)" do
      with_vcr_cassette Binance::Service::Com, "public/agg_trades_5" do
        response = client.agg_trades("BNBUSDT", 5)
        response.trades.map(&.price).should eq [35.7452, 35.7452, 35.7452, 35.7452, 35.7638]
      end
    end

    it "#agg_trades(\"BNBUSDT\", 5, 28432387)" do
      with_vcr_cassette Binance::Service::Com, "public/agg_trades_5_from_id" do
        response = client.agg_trades("BNBUSDT", limit: 5, from_id: 28432387)
        response.should be_a Binance::Responses::AggTradesResponse
        response.trades.size.should eq 5
        response.trades.map(&.price).should eq [35.7452, 35.7452, 35.7452, 35.7452, 35.7638]
      end
    end

    it "#trades(\"BOGUS\", 2)" do
      with_vcr_cassette Binance::Service::Com, "public/agg_trades_bogus" do
        response = client.agg_trades("BOGUS")
        response.should be_a Binance::Responses::AggTradesResponse
        response.success.should eq false
        response.trades.size.should eq 0
        response.error_message.should eq "Invalid symbol."
        response.error_code.should eq -1121
      end
    end
  end
end
