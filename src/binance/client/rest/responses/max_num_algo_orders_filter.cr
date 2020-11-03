module Binance::Responses
  # Typical server response
  #     {
  #       "filterType":"MAX_NUM_ALGO_ORDERS",
  #       "maxNumAlgoOrders":5
  #     }
  class MaxNumAlgoOrdersFilter < ExchangeFilter
    @[JSON::Field(key: "maxNumAlgoOrders")]
    getter max_num_algo_orders : Int32 = 0


    def validate(value)
      Array(String).new.tap do |errors|
        if limit > 0 && value > max_num_algo_orders
          errors << "#{value} exceeds max number of algo orders of #{max_num_algo_orders}"
        end
      end
    end

    def valid?(value : Float64)
      validate(value).empty?
    end
  end
end
