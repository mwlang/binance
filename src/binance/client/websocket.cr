require "./websocket/responses/data"
require "./websocket/responses/*"
require "./websocket/handler"
require "./websocket/listener"

module Binance
  class Websocket

    property api_key : String
    property secret_key : String

    def initialize(api_key = "", secret_key = "")
      @api_key = api_key
      @secret_key = secret_key
    end

    def ticker(markets : Array(String)) : Listener
      # Work in Progress
    end

  end
end
