require "../spec_helper"

describe Binance::Responses::Order do
  it "parses ACK order" do
    json_ack = <<-JSON
      {
        "symbol": "BTCUSDT",
        "orderId": 28,
        "clientOrderId": "6gCrw2kRUAF9CvJDGP16IP",
        "transactTime": 1507725176595
      }
    JSON

    puller = JSON::PullParser.new(json_ack)
    order = Binance::Responses::Order.new(puller)
    order.symbol.should eq "BTCUSDT"
    order.order_id.should eq 28
    order.client_order_id.should eq "6gCrw2kRUAF9CvJDGP16IP"
    order.transaction_time.to_s.should eq "2017-10-11 12:32:56 UTC"
    order.price.should eq 0.0
    order.original_quantity.should eq 0.0
    order.executed_quantity.should eq 0.0
    order.status.should eq "NEW"
    order.time_in_force.should eq ""
    order.order_type.should eq ""
    order.side.should eq ""
    order.stop_price.should eq 0.0
    order.fills.size.should eq 0
  end

  it "parses RESULT order" do
    json_result = <<-JSON
      {
        "symbol": "BTCUSDT",
        "orderId": 28,
        "clientOrderId": "6gCrw2kRUAF9CvJDGP16IP",
        "transactTime": 1507725176595,
        "price": "1.00000000",
        "origQty": "10.00000000",
        "executedQty": "10.00000000",
        "cummulativeQuoteQty": "10.00000000",
        "status": "FILLED",
        "timeInForce": "GTC",
        "type": "MARKET",
        "side": "SELL"
      }
    JSON

    puller = JSON::PullParser.new(json_result)
    order = Binance::Responses::Order.new(puller)
    order.symbol.should eq "BTCUSDT"
    order.order_id.should eq 28
    order.client_order_id.should eq "6gCrw2kRUAF9CvJDGP16IP"
    order.transaction_time.to_s.should eq "2017-10-11 12:32:56 UTC"
    order.price.should eq 1.0
    order.original_quantity.should eq 10.0
    order.executed_quantity.should eq 10.0
    order.status.should eq "FILLED"
    order.time_in_force.should eq "GTC"
    order.order_type.should eq "MARKET"
    order.side.should eq "SELL"
    order.stop_price.should eq 0.0
    order.fills.size.should eq 0
  end

  it "parses FULL order" do
    json_full = <<-JSON
      {
        "symbol": "BTCUSDT",
        "orderId": 28,
        "clientOrderId": "6gCrw2kRUAF9CvJDGP16IP",
        "transactTime": 1507725176595,
        "price": "1.00000000",
        "origQty": "10.00000000",
        "executedQty": "10.00000000",
        "cummulativeQuoteQty": "10.00000000",
        "status": "FILLED",
        "timeInForce": "GTC",
        "type": "MARKET",
        "side": "SELL",
        "fills": [
          {
            "price": "4000.00000000",
            "qty": "1.00000000",
            "commission": "4.00000000",
            "commissionAsset": "USDT"
          },
          {
            "price": "3999.00000000",
            "qty": "5.00000000",
            "commission": "19.99500000",
            "commissionAsset": "USDT"
          },
          {
            "price": "3998.00000000",
            "qty": "2.00000000",
            "commission": "7.99600000",
            "commissionAsset": "USDT"
          },
          {
            "price": "3997.00000000",
            "qty": "1.00000000",
            "commission": "3.99700000",
            "commissionAsset": "USDT"
          },
          {
            "price": "3995.00000000",
            "qty": "1.00000000",
            "commission": "3.99500000",
            "commissionAsset": "USDT"
          }
        ]
      }
    JSON

    puller = JSON::PullParser.new(json_full)
    order = Binance::Responses::Order.new(puller)
    order.symbol.should eq "BTCUSDT"
    order.order_id.should eq 28
    order.client_order_id.should eq "6gCrw2kRUAF9CvJDGP16IP"
    order.transaction_time.to_s.should eq "2017-10-11 12:32:56 UTC"
    order.price.should eq 1.0
    order.original_quantity.should eq 10.0
    order.executed_quantity.should eq 10.0
    order.status.should eq "FILLED"
    order.time_in_force.should eq "GTC"
    order.order_type.should eq "MARKET"
    order.side.should eq "SELL"
    order.stop_price.should eq 0.0
    order.fills.size.should eq 5

    fill = order.fills[-1]
    fill.price.should eq 3995.0
    fill.quantity.should eq 1.0
    fill.commission.should eq 3.995
    fill.commission_asset.should eq "USDT"
  end
end
