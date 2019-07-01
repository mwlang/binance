require "../spec_helper"

client = Binance::REST.new

describe Binance do

  it "#book_ticker(\"BNBUSDT\")" do
    with_vcr_cassette "public/book_ticker" do
      response = client.book_ticker("BNBUSDT")
      response.should be_a Binance::Responses::BookTickerResponse
      response.tickers.size.should eq 1
      response.tickers[0].symbol.should eq "BNBUSDT"
      response.tickers[0].bid_price.should eq 32.3925
      response.tickers[0].bid_quantity.should eq 17.0
      response.tickers[0].ask_price.should eq 32.4092
      response.tickers[0].ask_quantity.should eq 137.71
    end
  end

  it "#book_ticker" do
    with_vcr_cassette "public/book_ticker_all" do
      response = client.book_ticker
      response.should be_a Binance::Responses::BookTickerResponse
      response.success.should eq true
      response.tickers.size.should eq 554
      response.tickers[0].symbol.should eq "ETHBTC"
      response.tickers[0].bid_price.should eq 0.026726
    end
  end
end
