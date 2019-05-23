module Binance::Responses
  # Typical server response
  #     {
  #       "filterType":"MAX_NUM_ALGO_ORDERS",
  #       "maxNumAlgoOrders":5
  #     }
  class MaxNumAlgoOrdersFilter < ExchangeFilter
    @[JSON::Field(key: "maxNumAlgoOrders")]
    getter max_num_algo_orders : Int32 = 0
  end
end
