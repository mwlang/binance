module Binance::Responses
  # Typical server response
  #     {
  #       "filterType":"LOT_SIZE",
  #       "minQty":"0.00100000",
  #       "maxQty":"100000.00000000",
  #       "stepSize":"0.00100000"
  #     }
  class LotSizeFilter < ExchangeFilter
    @[JSON::Field(key: "minQty", converter: Binance::Converters::ToFloat)]
    getter min_quantity : Float64 = 0.0

    @[JSON::Field(key: "maxQty", converter: Binance::Converters::ToFloat)]
    getter max_quantity : Float64 = 0.0

    @[JSON::Field(key: "stepSize", converter: Binance::Converters::ToFloat)]
    getter step_size : Float64 = 0.0

    def decimals
      ((1.0 / step_size).to_i.to_s.size - 1)
    end

    def validate(value : Float64)
      Array(String).new.tap do |errors|
        errors << "#{value} is below min_quantity of #{min_quantity}" if min_quantity > 0 && value <= min_quantity
        errors << "#{value} exceeds max_quantity of #{max_quantity}" if max_quantity > 0 && value >= max_quantity
        errors << "#{value} is an invalid step_size #{step_size}" if step_size > 0 && value.round(decimals) != value
      end
    end

    def valid?(value : Float64)
      validate(value).empty?
    end
  end
end
