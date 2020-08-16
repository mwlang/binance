require "../spec_helper"

client = Binance::REST.new(api_key, api_secret)

# To get the below VCR cassettes passing:
# * ensure you have an open order that you can cancel
# * set the order_id of that order accordingly
describe Binance do
  context "active Order" do
    order_id = 20553269
    it "#cancel_order(\"BNBUSDC\", order_id: #{order_id})" do
      with_vcr_cassette "signed/cancel_order_bnbusdc_valid" do
        response = client.cancel_order("BNBUSDC", order_id: order_id)
        response.should be_a Binance::Responses::OrderResponse
        response.success.should eq true
        order = response.orders[0]
        order.status.should eq "CANCELED"
        (order.order_id > 0).should eq true
        order.transaction_time.to_s.should eq "2019-07-03 22:05:54 UTC"
        order.price.should eq 34.5
        (order.original_quantity > 0).should eq true
        order.executed_quantity.should eq 0.0
      end
    end

    it "#cancel_order(\"BNBUSDC\", order_id: #{order_id}) again" do
      with_vcr_cassette "signed/cancel_order_bnbusdc_already_cancelled" do
        response = client.cancel_order("BNBUSDC", order_id: order_id)
        response.should be_a Binance::Responses::OrderResponse
        response.success.should eq false
        response.error_message.should eq "Unknown order sent."
      end
    end
  end

  context "bogus Order" do
    order_id = 100
    it "#cancel_order(\"BNBUSDC\", order_id: #{order_id})" do
      with_vcr_cassette "signed/cancel_order_bnbusdc_bogus" do
        response = client.cancel_order("BNBUSDC", order_id: order_id)
        response.should be_a Binance::Responses::OrderResponse
        response.success.should eq false
        response.orders.size.should eq 0
        response.error_message.should eq "Unknown order sent."
      end
    end
  end
end
