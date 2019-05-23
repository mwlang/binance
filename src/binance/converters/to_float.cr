module Binance
  module Converters
    module ToFloat
      def self.from_json(pull : JSON::PullParser)
        pull.read_string.to_f
      end
    end
  end
end