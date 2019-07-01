require "../spec_helper"

client = Binance::REST.new(api_key, api_secret)

describe Binance do
  it "#account" do
    with_vcr_cassette "signed/account" do
      response = client.account
      response.should be_a Binance::Responses::AccountResponse
      response.success.should eq true
      response.maker_commission.should eq 10
      response.taker_commission.should eq 10
      response.buyer_commission.should eq 0
      response.seller_commission.should eq 0
      response.can_trade.should eq true
      response.can_deposit.should eq true
      response.update_time.to_s.should eq "2019-07-01 21:38:08 UTC"
      response.account_type.should eq "MARGIN"
      response.balances.size.should eq 182
      balance = response.balances[0]
      balance.asset.should eq "BTC"
      balance.free.should eq 0.61242848
      balance.locked.should eq 0
    end
  end
end
