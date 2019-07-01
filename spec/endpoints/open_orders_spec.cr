require "../spec_helper"

client = Binance::REST.new(api_key, api_secret)

describe Binance do

  # To capture a VCR cassette for this scenario to pass:
  #  * You should have two open orders at the time this vcr cassette is recorded
  #  * Open a Buy order for BNB/USDT with a price well below current price
  #  * Open a Sell order for BNB/USDT with a price well above current price
  it "#open_orders(\"BNBUSDT\")" do
    with_vcr_cassette "signed/open_orders_bnbusdt" do
      response = client.open_orders("BNBUSDT")
      response.should be_a Binance::Responses::OrderResponse
      response.success.should eq true
      response.orders.size.should eq 2
      response.orders.map(&.symbol).should eq ["BNBUSDT", "BNBUSDT"]
      response.orders.map(&.order_id.nil?).should eq [false, false]
      response.orders.map(&.stop_price.zero?).should eq [true, false]
      response.orders.map(&.side).should eq ["BUY", "SELL"]
    end
  end
end
