require "../../spec_helper"

json = <<-JSON
  {
    "filterType":"MAX_NUM_ALGO_ORDERS",
    "maxNumAlgoOrders":5
  }
JSON

describe Binance::Responses::MaxNumAlgoOrdersFilter do
  it "parses" do
    filter = Binance::Responses::MaxNumAlgoOrdersFilter.from_json(json)
    filter.max_num_algo_orders.should eq 5
  end
end
