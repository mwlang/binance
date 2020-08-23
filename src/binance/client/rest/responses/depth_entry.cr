module Binance::Responses
  # Typical server response
  # [
  #   "4.00000000",     // PRICE
  #   "431.00000000"    // QTY
  # ]
  class DepthEntry
    getter price : Float64 = 0.0
    getter quantity : Float64 = 0.0

    def initialize(pull : JSON::PullParser)
      pull.read_begin_array
      @price = pull.read_string.to_f
      @quantity = pull.read_string.to_f
      pull.read_end_array
    end

    def to_json(builder)
      builder.array do
        builder.string @price.to_s
        builder.string @quantity.to_s
      end
    end
  end
end
