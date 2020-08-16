module Binance::Responses
  class RateLimit
    include JSON::Serializable

    @[JSON::Field(key: "rateLimitType")]
    getter rate_limit_type : String = ""

    @[JSON::Field(key: "interval")]
    getter interval : String = ""

    @[JSON::Field(key: "intervalNum")]
    getter interval_number : Int32 = 1

    @[JSON::Field(key: "limit")]
    getter limit : Int32 = 0
  end
end
