require "../spec_helper"

client = Binance::REST.new(api_key, api_secret)

# To get the below VCR cassettes passing:
# * ensure you have BNB free to sell
# The specs will create SELL orders on BNB to USDC
# * The MARKET sells will execute.
# * The LIMIT sells may or may not execute depending on current BNB prices.
#   Intention of LIMIT sell is to set price *above* current market value.
describe Binance do
  context "MARKET SELL" do
    # To get this VCR cassette passing:
    # * ensure you have BNB free to sell
    it "#new_order(\"BNBUSDC\", side: \"SELL\", order_type: \"MARKET\", quantity: 1.0)" do
      with_vcr_cassette "signed/new_order_bnbusdc_sell_market" do
        response = client.new_order("BNBUSDC", side: "SELL", order_type: "MARKET", quantity: 1.0)
        response.should be_a Binance::Responses::OrderResponse
        response.success.should eq true
        order = response.orders[0]
        order.status.should eq "FILLED"
        (order.order_id > 0).should eq true
        order.transaction_time.to_s.should eq "2019-07-03 20:53:48 UTC"
        order.price.should eq 0.0
        (order.original_quantity > 0).should eq true
        order.executed_quantity.should eq order.original_quantity
      end
    end

    # To get this VCR cassette passing:
    # * ensure you have BNB free to sell
    it "#new_order(\"BNBUSDC\", side: \"SELL\", order_type: \"MARKET\", quantity: 1.0, response_type: \"FULL\")" do
      with_vcr_cassette "signed/new_order_bnbusdc_sell_market_ack_response" do
        response = client.new_order("BNBUSDC", side: "SELL", order_type: "MARKET", quantity: 0.5, response_type: "ACK")
        response.should be_a Binance::Responses::OrderResponse
        response.success.should eq true
        order = response.orders[0]
        order.status.should eq "NEW"
        (order.order_id > 0).should eq true
        order.transaction_time.to_s.should eq "2019-07-03 21:12:59 UTC"
        order.price.should eq 0.0
        (order.original_quantity > 0).should eq false
        order.executed_quantity.should eq order.original_quantity
      end
    end
  end

  context "LIMIT SELL" do
    it "#new_order(\"BNBUSDC\", side: \"SELL\", order_type: \"LIMIT\", quantity: 1.0)" do
      with_vcr_cassette "signed/new_order_bnbusdc_sell_limit_wo_time_in_force" do
        response = client.new_order("BNBUSDC", side: "SELL", order_type: "LIMIT", quantity: 1.0)
        response.should be_a Binance::Responses::OrderResponse
        response.success.should eq false
        response.orders.size.should eq 0
        response.error_code.should eq -1102
        response.error_message.should eq "Mandatory parameter 'timeInForce' was not sent, was empty/null, or malformed."
      end
    end

    it "#new_order(\"BNBUSDC\", side: \"SELL\", order_type: \"LIMIT\", quantity: 1.0)" do
      with_vcr_cassette "signed/new_order_bnbusdc_sell_limit_wo_price" do
        response = client.new_order("BNBUSDC", side: "SELL", order_type: "LIMIT", time_in_force: "GTC", quantity: 1.0)
        response.should be_a Binance::Responses::OrderResponse
        response.success.should eq false
        response.orders.size.should eq 0
        response.error_code.should eq -1102
        response.error_message.should eq "Mandatory parameter 'price' was not sent, was empty/null, or malformed."
      end
    end

    it "#new_order(\"BNBUSDC\", side: \"SELL\", order_type: \"LIMIT\", quantity: 1.0)" do
      with_vcr_cassette "signed/new_order_bnbusdc_sell_limit_valid" do
        response = client.new_order("BNBUSDC", side: "SELL", order_type: "LIMIT", time_in_force: "GTC", quantity: 1.0, price: 34.5)
        response.should be_a Binance::Responses::OrderResponse
        response.success.should eq true
        order = response.orders[0]
        order.status.should eq "NEW"
      end
    end
  end
end
