module Binance
  module Converters
    # :nodoc:
    module ToFloat
      def self.from_json(pull : JSON::PullParser)
        pull.kind.float? ? pull.read_float : pull.read_string.to_f
      end

      def self.to_json(value : Float64, builder : JSON::Builder)
        builder.number value
      end
    end
  end
end
