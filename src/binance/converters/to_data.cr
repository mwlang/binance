module Binance
  module Converters
    # :nodoc:
    module ToData
      def self.from_json(pull : JSON::PullParser)

        Binance::Responses::ExchangeFilter.from_array(pull.read_raw)
      end
    end
  end
end
