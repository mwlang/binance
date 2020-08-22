module Binance
  module Converters
    # :nodoc:
    module ToTime
      def self.from_json(pull : JSON::PullParser)
        value = pull.read_int
        t = Time.unix_ms(value)
        t.year <= 2015 ? Time.unix(value) : t
      end
    end
  end
end
