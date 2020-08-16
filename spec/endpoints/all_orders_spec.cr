require "../spec_helper"

client = Binance::REST.new(api_key, api_secret)

describe Binance do
  # To get this spec passing with a locally recorded cassette,
  # * Have at least two orders (any status) on BNBUSDC against your account
  it "#all_orders(\"BNBUSDC\")" do
    with_vcr_cassette "signed/all_orders_bnbusdc" do
      response = client.all_orders(symbol: "BNBUSDC")
      response.should be_a Binance::Responses::OrderResponse
      (response.orders.size > 2).should eq true
      response.success.should eq true
      order = response.orders[0]
      order.order_id.zero?.should eq false
      order.price.zero?.should eq false
      (order.original_quantity > 1.0).should eq true
      (order.executed_quantity > 1.0).should eq true
      (order.cummulative_quote_quantity > 10).should eq true
      order.status.should eq "FILLED"
      order.time_in_force.should eq "GTC"
      order.fills.size.should eq 0
    end
  end
end
