require "../spec_helper"

client = Binance::REST.new(api_key, api_secret)

describe Binance do

  it "#all_orders(\"BNBUSDC\")" do
    with_vcr_cassette "signed/all_orders_bnbusdc" do
      response = client.all_orders(symbol: "BNBUSDC")
      response.should be_a Binance::Responses::OrderResponse
      response.orders.size.should eq 10
      response.success.should eq true
      order = response.orders[0]
      order.order_id.zero?.should eq false
      order.price.zero?.should eq false
      (order.original_quantity > 1.0).should eq true
      (order.executed_quantity > 1.0).should eq true
      (order.cummulative_quote_quantity > 1000).should eq true
      order.status.should eq "FILLED"
      order.time_in_force.should eq "GTC"
      order.fills.size.should eq 0
    end
  end
end
