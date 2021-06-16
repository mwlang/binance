module Binance::Responses
  class OcoOrder
    include JSON::Serializable

    @[JSON::Field(key: "symbol")]
    getter symbol : String = ""

    @[JSON::Field(key: "orderListId")]
    getter order_list_id : Int64 = 0

    @[JSON::Field(key: "listStatusType")]
    getter list_status_type : String = ""

    @[JSON::Field(key: "listOrderStatus")]
    getter list_order_status : String = ""

    @[JSON::Field(key: "listClientOrderId")]
    getter list_client_order_id : String = ""

    @[JSON::Field(key: "transactionTime", converter: Binance::Converters::ToTime)]
    getter transaction_time : Time = Time.utc
  end
end
