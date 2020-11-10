require "./websocket/responses/data"
require "./websocket/responses/trade_base"
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

    macro stream(method_name, stream_name)
      def {{method_name}}(markets : (Array(String) | String), handler : (Binance::Handler | Binance::Handler.class), timeout : Time::Span = 0.seconds)
        Binance::Listener.new markets, {{stream_name}}, handler, timeout
      end
    end

    # The Aggregate Trade Streams push trade information that is aggregated for a single taker order.
    stream aggregate_trade, "aggTrade"

    # The Trade Streams push raw trade information; each trade has a unique buyer and seller.
    stream trade, "trade"

    # 24hr rolling window ticker statistics for a single symbol. These are NOT the statistics
    # of the UTC day, but a 24hr rolling window for the previous 24hrs.
    stream ticker, "ticker"

    # Pushes any update to the best bid or ask's price or quantity in real-time for a specified symbol.
    stream book_ticker, "bookTicker"

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
    def depth(markets, handler, speed="", timeout = 0.seconds) : Listener
      stream_name = speed == "" ? "depth" : "depth@#{speed}"
      Binance::Listener.new markets, stream_name, handler, timeout
    end

    def depth(markets, handler) : Listener
      depth markets, handler, "", 0.seconds
    end

    def depth(markets, handler, timeout : Time::Span) : Listener
      depth markets, handler, "", timeout
    end

    def combo(markets, streams, handler, timeout = 0.seconds) : Listener
      Binance::Listener.new markets, streams, handler, timeout
    end
  end
end
