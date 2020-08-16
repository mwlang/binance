module Binance
  module Converters
    # :nodoc:
    module ToFilter
      def self.from_json(pull : JSON::PullParser)
        Binance::Responses::ExchangeFilter.from_array(pull.read_raw)
      end
    end
  end
end
