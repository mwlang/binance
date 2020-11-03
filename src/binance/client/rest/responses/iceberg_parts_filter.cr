module Binance::Responses
  # Typical server response
  #     {
  #       "filterType":"ICEBERG_PARTS",
  #       "limit":10
  #     }
  #
  # The ICEBERG_PARTS filter defines the maximum parts an iceberg order can have.
  # The number of ICEBERG_PARTS is defined as CEIL(qty / icebergQty).
  #
  class IcebergPartsFilter < ExchangeFilter
    @[JSON::Field(key: "limit")]
    getter limit : Int32 = 0

    def validate(value)
      Array(String).new.tap do |errors|
        errors << "#{value} exceeds limit of #{limit}" if limit > 0 && value > limit
      end
    end

    def valid?(value : Float64)
      validate(value).empty?
    end
  end
end
