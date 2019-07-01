# require "./client/sign_request_middleware"
# require "./client/timestamp_request_middleware"
# require "./client/clients"
require "./rest/endpoints"
require "./rest/methods"
require "./rest/responses/*"

module Binance

  class REST
    include Binance::Endpoints
    include Binance::Methods

    BASE_URL = "https://api.binance.com/api"

    def to_query(params)
      params.map{ |k, v| "#{k.to_s}=#{v.to_s}" }.join("&")
    end      

    def public_fetch(url, params)
      connection = Cossack::Client.new(BASE_URL) do |client|
        client.headers["Content-Type"] = "application/json"
        client.headers["Accept"] = "application/json"
      end
      url_with_params = "#{url}?#{to_query(params)}"
      connection.get url_with_params
    end

    def verified_fetch(url, params)
      raise "No API KEY assigned" if api_key.to_s.blank?
      connection = Cossack::Client.new(BASE_URL) do |client|
        client.headers["Content-Type"] = "application/json"
        client.headers["Accept"] = "application/json"
        client.headers["X-MBX-APIKEY"] = api_key
      end
      url_with_params = "#{url}?#{to_query(params)}"
      connection.get url_with_params
    end

    def hmac(data : String)
      OpenSSL::HMAC.hexdigest(:sha256, secret_key, data)
    end

    macro fetch(client, endpoint, response_klass, args)
      begin
        if response = {{client.id}}_fetch(Binance::Endpoints::ENDPOINTS[{{endpoint}}], {{args}})
          if response.status == 200
            {{response_klass}}.from_json(response.body).tap do |resp| 
              resp.response = response
              resp.after_serialization
            end
          else
            {{response_klass}}.from_error(response)
          end
        else
          {{response_klass}}.from_failure(response)
        end
      rescue ex : Exception
        {{response_klass}}.from_exception(ex)
      end
    end

    macro fetch(client, endpoint, response_klass)
      fetch({{client}}, {{endpoint}}, {{response_klass}}, NamedTuple.new)
    end

    property api_key : String
    property secret_key : String

    def initialize(@api_key = "", @secret_key = "")
      # @clients = {} of Symbol => Binance::Client
      # @clients[:public]   = public_client adapter
      # @clients[:verified] = verified_client api_key, adapter
      # @clients[:signed]   = signed_client api_key, secret_key, adapter
      # @clients[:withdraw] = withdraw_client api_key, secret_key, adapter
      # @clients[:public_withdraw] = public_withdraw_client adapter
    end

    # METHODS.each do |method|
    #   define_method(method[:name]) do |options = {}|
    #     response = @clients[method[:client]].send(method[:action]) do |req|
    #       req.url ENDPOINTS[method[:endpoint]]
    #       req.params.merge! options.map { |k, v| [camelize(k.to_s), v] }.to_h
    #     end
    #     response.body
    #   end
    # end

    # def self.add_query_param(query, key, value)
    #   query = query.to_s
    #   query << "&" unless query.empty?
    #   query << "#{Faraday::Utils.escape key}=#{Faraday::Utils.escape value}"
    # end

    # def camelize(str)
    #   str.split("_")
    #      .map.with_index { |word, i| i.zero? ? word : word.capitalize }.join
    # end
  end
end
