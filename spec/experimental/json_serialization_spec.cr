# # Goal is to find a way to serialize array of filters where each filter is it's own class
# # This file was originally used to solve for solution that's currently in use.
# # However, it's since changed in attempt to avoid double-parsing.
# require "spec"
# require "json"

# json = <<-JSON
#   {
#     "symbol":"ETHBTC",
#     "status":"TRADING",
#     "filters":[
#       {
#         "filterType":"PRICE_FILTER",
#         "minPrice":"0.00000100",
#         "maxPrice":"100000.00000000",
#         "tickSize":"0.00000100"
#       },
#       {
#         "filterType":"PERCENT_PRICE",
#         "multiplierUp":"5",
#         "multiplierDown":"0.2",
#         "avgPriceMins":5
#       },
#       {
#         "filterType":"LOT_SIZE",
#         "minQty":"0.00100000",
#         "maxQty":"100000.00000000",
#         "stepSize":"0.00100000"
#       }
#   ]}
# JSON

# class ExchangeFilter
#   include JSON::Serializable
#   include JSON::Serializable::Unmapped

#   @[JSON::Field(key: "filterType")]
#   getter filter_type : String = ""
# end

# class PercentPriceFilter < ExchangeFilter
#   @[JSON::Field(key: "multiplierUp", converter: ToFloat)]
#   getter multiplier_up : Float64 = 0.0

#   @[JSON::Field(key: "multiplierDown", converter: ToFloat)]
#   getter multiplier_down : Float64 = 0.0

#   @[JSON::Field(key: "avgPriceMins")]
#   getter avg_price_mins : Int32 = 0
# end

# class PriceFilter < ExchangeFilter
#   @[JSON::Field(key: "minPrice", converter: ToFloat)]
#   getter min_price : Float64 = 0.0

#   @[JSON::Field(key: "maxPrice", converter: ToFloat)]
#   getter max_price : Float64 = 0.0

#   @[JSON::Field(key: "tickSize", converter: ToFloat)]
#   getter tick_size : Float64 = 0.0
# end

# module ToFloat
#   def self.from_json(pull : JSON::PullParser)
#     pull.read_string.to_f
#   end
# end

# module ToFilter
#   def self.from_json(pull : JSON::PullParser)
#     filters = [] of ExchangeFilter
#     pull.read_array do
#       pull.read_object do |key|
#         puts "*" * 40, key.inspect, "*" * 40
#         value = pull.read_string
#         filters << case value
#         when "PRICE_FILTER" then PriceFilter.new pull
#         when "PERCENT_PRICE" then PercentPriceFilter.new pull
#         else ExchangeFilter.new pull
#         end
#       end
#     end
#     filters
#     # JSON.parse(pull.read_raw).as_a.map do |item|
#     #   puts "*" * 40, item.inspect, "*" * 40
#     #   case item["filterType"]
#     #   when "PRICE_FILTER" then PriceFilter.from_json item.to_json
#     #   when "PERCENT_PRICE" then PercentPriceFilter.from_json item.to_json
#     #   else ExchangeFilter.from_json(item.to_json)
#     #   end
#     # end

#   end
# end

# class ExchangeSymbol
#   include JSON::Serializable

#   @[JSON::Field(key: "symbol")]
#   getter symbol : String = ""

#   @[JSON::Field(key: "status")]
#   getter status : String = ""

#   @[JSON::Field(key: "filters", converter: ToFilter)]
#   getter filters : Array(ExchangeFilter) = [] of ExchangeFilter
# end

# describe Symbol do
#   it "parses" do
#     ExchangeSymbol.from_json(json).should be_a ExchangeSymbol
#     ExchangeSymbol.from_json(json).filters[0].should be_a PriceFilter
#     ExchangeSymbol.from_json(json).filters[1].should be_a PercentPriceFilter
#     ExchangeSymbol.from_json(json).filters[2].should be_a ExchangeFilter
#     ExchangeSymbol.from_json(json).filters[2].json_unmapped["minQty"].should eq "0.00100000"
#   end
# end
