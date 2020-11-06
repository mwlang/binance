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

    def ticker(markets : Array(String), handler : Binance::Handler.class, timeout = 0.seconds) : Listener
      Binance::Listener.new markets, "ticker", handler, timeout
    end

    def book_ticker(markets : Array(String), handler : Binance::Handler.class, timeout = 0.seconds) : Listener
      Binance::Listener.new markets, "bookTicker", handler, timeout
    end

    # Diff. Depth Stream
    # Order book price and quantity depth updates used to locally manage an order book.
    #
    # Stream Name: <symbol>@depth OR <symbol>@depth@100ms
    #
    # Update Speed: 1000ms or 100ms
    #
    # How to manage a local order book correctly
    # 1. Open a stream to wss://stream.binance.com:9443/ws/bnbbtc@depth.
    # 2. Buffer the events you receive from the stream.
    # 3. Get a depth snapshot from https://api.binance.com/api/v3/depth?symbol=BNBBTC&limit=1000 .
    # 4. Drop any event where u is <= lastUpdateId in the snapshot.
    # 5. The first processed event should have U <= lastUpdateId+1 AND u >= lastUpdateId+1.
    # 6. While listening to the stream, each new event's U should be equal to the previous event's u+1.
    # 7. The data in each event is the absolute quantity for a price level.
    # 8. If the quantity is 0, remove the price level.
    # 9. Receiving an event that removes a price level that is not in your local order book can happen and is normal.
    def depth(markets : Array(String), handler : Binance::Handler.class, speed="", timeout = 0.seconds) : Listener
      stream_name = speed == "" ? "depth" : "depth@#{speed}"
      Binance::Listener.new markets, stream_name, handler, timeout
    end
  end
end
