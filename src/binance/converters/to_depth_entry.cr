module Binance
  module Converters
    # :nodoc:
    module ToDepthEntry
      def self.from_json(pull : JSON::PullParser)
        result = [] of Binance::Responses::DepthEntry
        pull.read_begin_array
          while pull.kind != :end_array
            result << Binance::Responses::DepthEntry.new(pull)
          end
        pull.read_end_array
        result
      end
    end
  end
end
