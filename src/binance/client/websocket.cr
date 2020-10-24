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

    def ticker(markets : Array(String), handler : Binance::Handler) : Listener
      Binance::Listener.new markets, "ticker", handler
    end

    def book_ticker(markets : Array(String), handler : Binance::Handler.class) : Listener
      Binance::Listener.new markets, "bookTicker", handler
    end
  end
end
