require "./rest/endpoints"
require "./rest/http_methods"
require "./rest/responses/*"

module Binance
  class REST
    include Binance::Endpoints
    include Binance::HttpMethods

    property api_key : String
    property secret_key : String

    def initialize(api_key = "", secret_key = "")
      @api_key = api_key
      @secret_key = secret_key
    end

    def hmac(data : String)
      OpenSSL::HMAC.hexdigest(:sha256, secret_key, data)
    end

  end
end
