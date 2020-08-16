require "../spec_helper"

client = Binance::REST.new(api_key, api_secret)

describe Binance do
  it "#my_trades(\"BNBUSDC\", limit: 5)" do
    with_vcr_cassette "signed/my_trades_limit_5" do
      response = client.my_trades("BNBUSDC", limit: 5)
      response.should be_a Binance::Responses::MyTradesResponse
      response.success.should eq true
      response.trades.size.should eq 5
      response.trades.map(&.price).should eq [29.2114, 30.0246, 30.0008, 32.2125, 32.2125]
      response.trades.map(&.order_id).should eq [15695591, 15855132, 15855132, 17456164, 17456164]
      response.trades.map(&.is_buyer).should eq [true, false, false, true, true]
      response.trades.map(&.is_maker).should eq [true, false, false, true, true]
    end
  end
end
