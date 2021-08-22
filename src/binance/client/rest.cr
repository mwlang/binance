require "./rest/endpoints"
require "./rest/http_methods"
require "./rest/responses/*"

module Binance
  enum Service
    Com
    Us
  end

  class REST
    include Binance::Endpoints
    include Binance::HttpMethods

    property api_key : String
    property secret_key : String
    property service : Service

    def initialize(
        @api_key = "",
        @secret_key = "",
        @service = Binance::Service::Com
      )
    end

    def base_url
      case service
      when Binance::Service::Com then "https://api.binance.com/api"
      when Binance::Service::Us then "https://api.binance.us/api"
      else raise "Unknown service #{service.inspect}"
      end
    end

    def hmac(data : String)
      OpenSSL::HMAC.hexdigest(:sha256, secret_key, data)
    end
  end
end
