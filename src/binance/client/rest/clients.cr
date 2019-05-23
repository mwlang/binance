# module Binance
#   module Client
#     class REST
#        BASE_URL = "https://api.binance.com"

#       # params = {
#       #   symbol: market_symbol.upcase,
#       #   limit: limit
#       # }
#       # full_path = QueryParamHelper.set_query_params(endpoint, params)
#       # response = HTTP::Client.get(full_path)
#       # data = JSON.parse(response.body)
#       # update(data)          
#       #

#       def public_client
#         Faraday.new(url: "#{BASE_URL}/api") do |conn|
#           conn.request :json
#           conn.response :json, content_type: /\bjson$/
#           conn.adapter adapter
#         end
#       end

#       def verified_client(api_key)
#         Faraday.new(url: "#{BASE_URL}/api") do |conn|
#           conn.response :json, content_type: /\bjson$/
#           conn.headers["X-MBX-APIKEY"] = api_key
#           conn.adapter adapter
#         end
#       end

#       def signed_client(api_key, secret_key)
#         Faraday.new(url: "#{BASE_URL}/api") do |conn|
#           conn.request :json
#           conn.response :json, content_type: /\bjson$/
#           conn.headers["X-MBX-APIKEY"] = api_key
#           conn.use TimestampRequestMiddleware
#           conn.use SignRequestMiddleware, secret_key
#           conn.adapter adapter
#         end
#       end

#       def public_withdraw_client
#         Faraday.new(url: "#{BASE_URL}/wapi") do |conn|
#           conn.request :json
#           conn.response :json, content_type: /\bjson$/
#           conn.adapter adapter
#         end
#       end

#       def withdraw_client(api_key, secret_key)
#         Faraday.new(url: "#{BASE_URL}/wapi") do |conn|
#           conn.request :url_encoded
#           conn.response :json, content_type: /\bjson$/
#           conn.headers["X-MBX-APIKEY"] = api_key
#           conn.use TimestampRequestMiddleware
#           conn.use SignRequestMiddleware, secret_key
#           conn.adapter adapter
#         end
#       end
#     end
#   end
# end