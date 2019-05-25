module Binance
  module Converters
    # :nodoc:
    module ToPong
      def self.from_json(pull : JSON::PullParser)
        pull.read_null
      end
    end
  end
end