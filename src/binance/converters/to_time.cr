module Binance
  module Converters
    module ToTime
      def self.from_json(pull : JSON::PullParser)
        value = pull.read_int
        Time.unix_ms(value)
      end
    end
  end
end