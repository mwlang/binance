module Binance::Responses
  # Typical Server Response:
  #     {
  #       "makerCommission": 15,
  #       "takerCommission": 15,
  #       "buyerCommission": 0,
  #       "sellerCommission": 0,
  #       "canTrade": true,
  #       "canWithdraw": true,
  #       "canDeposit": true,
  #       "updateTime": 123456789,
  #       "balances": [
  #         {
  #           "asset": "BTC",
  #           "free": "4723846.89208129",
  #           "locked": "0.00000000"
  #         },
  #         {
  #           "asset": "LTC",
  #           "free": "4763368.68006011",
  #           "locked": "0.00000000"
  #         }
  #       ]
  #     }
  class AccountResponse < Responses::ServerResponse
    @[JSON::Field(key: "makerCommission")]
    getter maker_commission : Int32 = 0

    @[JSON::Field(key: "takerCommission")]
    getter taker_commission : Int32 = 0

    @[JSON::Field(key: "buyerCommission")]
    getter buyer_commission : Int32 = 0

    @[JSON::Field(key: "sellerCommission")]
    getter seller_commission : Int32 = 0

    @[JSON::Field(key: "canTrade")]
    getter can_trade : Bool = false

    @[JSON::Field(key: "canWithdraw")]
    getter can_withdraw : Bool = false

    @[JSON::Field(key: "canDeposit")]
    getter can_deposit : Bool = false

    @[JSON::Field(key: "updateTime", converter: Binance::Converters::ToTime)]
    getter update_time : Time? = nil

    @[JSON::Field(key: "accountType")]
    getter account_type : String = ""

    @[JSON::Field(key: "balances")]
    property balances : Array(BalanceEntry) = [] of Binance::Responses::BalanceEntry
  end
end
