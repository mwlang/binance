require "./order"

module Binance::Responses
  class MarginOrder < Order
    include JSON::Serializable

    @[JSON::Field(key: "marginBuyBorrowAmount", converter: Binance::Converters::ToFloat)]
    getter margin_buy_borrow_amount : Float64? = 0.0

    @[JSON::Field(key: "marginBuyBorrowAsset")]
    getter margin_buy_borrow_asset : String? = ""

    @[JSON::Field(key: "isIsolated")]
    getter is_isolated : Bool
  end
end
