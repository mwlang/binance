# require "./endpoints/time"

module Binance::Methods
  include Binance::Responses

  # Returns: `PingResponse`
  def ping
    fetch :public, :ping, PingResponse
  end

  # Returns `TimeResponse`
  def time
    fetch :public, :time, TimeResponse
  end

  # Returns `ExchangeInfoResponse`
  def exchange_info
    fetch :public, :exchange_info, ExchangeInfoResponse
  end

  def depth(symbol : String, limit : Int32 = 5)
    fetch :public, :depth, DepthResponse, {symbol: symbol.upcase, limit: limit}
  end
end
# module Binance
#   class REST
#     include Endpoint::Time
#     # METHODS.each do |method|
#     #   define_method(method[:name]) do |options = {}|
#     #     response = @clients[method[:client]].send(method[:action]) do |req|
#     #       req.url ENDPOINTS[method[:endpoint]]
#     #       req.params.merge! options.map { |k, v| [camelize(k.to_s), v] }.to_h
#     #     end
#     #     response.body
#     #   end
#     # end      
#     # macro action(name, client, action, endpoint, options)
#     #   response = client.{{action.id}}
#     # end

#     def endpoint(selector)
#       "#{BASE_URL}/api/#{ENDPOINTS[selector]}"
#     end

#     def ping
#       # params = {
#       #   symbol: market_symbol.upcase,
#       #   limit: limit
#       # }
#       # full_path = QueryParamHelper.set_query_params(endpoint, params)
#       if response = HTTP::Client.get(endpoint(:ping))
#         JSON.parse(response.body)
#       else
#         nil
#       end
#     end

#     # struct TimeResponse
#     #   include JSON::Serializable

#     #   @[JSON::Field(key: "serverTime", converter: Binance::Converters::ToTime)]
#     #   getter server_time : Time
#     # end

#   end
# end
