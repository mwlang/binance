module Binance
  module Converters
    module ToPong
      def self.from_json(pull : JSON::PullParser)
        pull.read_null
      end
    end
  end
end