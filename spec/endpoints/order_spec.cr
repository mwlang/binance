require "../spec_helper"

client = Binance::REST.new(api_key, api_secret)

describe Binance do

  it "#order(\"BNBUSDC\")" do
    with_vcr_cassette "signed/order_bnbusdc" do
      response = client.order("BNBUSDC")
      response.should be_a Binance::Responses::OrderResponse
      response.error_message.should eq "Param 'origClientOrderId' or 'orderId' must be sent, but both were empty/null!"
      response.error_code.should eq -1102
      response.orders.size.should eq 0
      response.success.should eq false
      # response.tickers[0].symbol.should eq "BNBUSDT"
      # response.tickers[0].price.should eq 32.5001
    end
  end
end
