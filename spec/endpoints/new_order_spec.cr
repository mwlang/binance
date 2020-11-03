require "../spec_helper"

client = Binance::REST.new(api_key, api_secret)

# To get the below VCR cassettes passing:
# * ensure you have BNB free to sell
# The specs will create SELL orders on BNB to USDC
# * The MARKET sells will execute.
# * The LIMIT sells may or may not execute depending on current BNB prices.
#   Intention of LIMIT sell is to set price *above* current market value.
describe Binance do
  context "MARKET BUY" do
    # To get this VCR cassette passing:
    # * ensure you have enough USDC free to buy BNB
    # * execute an order that fills against BNBUSDC
    # * **change** the bnbusdc_order_id of the spec to match!
    order_id = 86525339
    it "#new_order(\"BNBUSDC\", side: \"BUY\", order_type: \"MARKET\", quantity: 1.0, response_type: \"FULL\")" do
      with_vcr_cassette "signed/new_order_bnbusdc_buy_market_full_response" do
        response = client.new_order("BNBUSDC", side: "BUY", order_type: "MARKET", quantity: 1.0, response_type: "FULL")
        response.should be_a Binance::Responses::OrderResponse
        response.success.should eq true
        order = response.orders[0]
        order.status.should eq "FILLED"
        order.order_id.should eq order_id
        order.price.should eq 0.0
        order.effective_fill_price.should eq 26.9145
        order.average_price.should eq 26.9145
        order.original_quantity.should eq 1.0
        order.executed_quantity.should eq order.original_quantity
      end
    end
    it "fetches the newly filled order" do
      with_vcr_cassette "signed/order_bnbusdc_fetch_after_market_buy" do
        response = client.get_order("BNBUSDC", order_id: order_id)
        pp! response
        response.success.should eq true
        response.orders.size.should eq 1
        order = response.orders[0]
        order.order_id.should eq order_id
        order.price.should eq 0.0
        order.average_price.should eq 26.9145
        order.original_quantity.should eq 1.0
        order.executed_quantity.should eq 1.0
        order.cummulative_quote_quantity.should eq 26.9145
        order.status.should eq "NEW"
        order.time_in_force.should eq "GTC"
      end
    end
  end

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
