require "../spec_helper"

client = Binance::REST.new(api_key, api_secret)

describe Binance do

  it "#get_order(\"BNBUSDC\")" do
    with_vcr_cassette "signed/order_wo_order_id" do
      response = client.get_order("BNBUSDC")
      response.should be_a Binance::Responses::OrderResponse
      response.error_message.should eq "Param 'origClientOrderId' or 'orderId' must be sent, but both were empty/null!"
      response.error_code.should eq -1102
      response.orders.size.should eq 0
      response.success.should eq false
    end
  end

  # To get this VCR cassette passing:
  # * execute an order that fills against BNBUSDC
  # * **change** the bnbusdc_order_id of the spec to match!
  order_id = 178365611
  it "#get_order(\"BNBUSDT\", order_id: #{order_id})" do
    with_vcr_cassette "signed/order_bnbusdt_w_order_id" do
      response = client.get_order("BNBUSDT", order_id: order_id)
      response.should be_a Binance::Responses::OrderResponse
      response.success.should eq true
      response.orders.size.should eq 1
      order = response.orders[0]
      order.order_id.should eq order_id
      order.price.zero?.should eq false
      (order.original_quantity > 1.0).should eq true
      order.executed_quantity.should eq 0.0
      order.cummulative_quote_quantity.should eq 0.0
      order.status.should eq "NEW"
      order.time_in_force.should eq "GTC"
    end
  end
end
