Spec2.describe Binance::Responses::MaxNumAlgoOrdersFilter do
  let(json) do
    <<-JSON 
      {
        "filterType":"MAX_NUM_ALGO_ORDERS",
        "maxNumAlgoOrders":5
      }
    JSON
  end

  let(filter) { described_class.from_json(json) }

  it "parses" do
    expect(filter.max_num_algo_orders).to eq 5
  end
end

