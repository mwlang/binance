require "../src/binance"

# Each market will instantiate it's own TickerHandler
class BookTickerHandler < Binance::Handler

  def initialize(@symbol : String)
    super(@symbol)
    @channel = Channel(Binance::Responses::Websocket::BookTicker).new
    @mutex = Mutex.new
    collect_tickers
  end

  # Over-engineered example, but shows using a channel in the Handler's update
  # to send the streamed JSON somewhere.  Here, we break the loop if the
  # Listener stopped because the websocket stream stopped receiving new data.
  #
  # We use this knowledge to know when to break the loop and restart the
  # Listener and thus the websocket stream.
  #
  def collect_tickers
    spawn do
      loop do
        break if stopped?
        ticker = @channel.receive
        puts [
          ticker.symbol.rjust(12),
          "bid:",
          ("%0.8f" % ticker.bid_price).rjust(16),
          "/",
          ("%0.6f" % ticker.bid_quantity).rjust(16),
          "ask:",
          ("%0.8f" % ticker.ask_price).rjust(16),
          "/",
          ("%0.6f" % ticker.ask_quantity).rjust(16),
        ].join(" ")
      end
    end
  end

  # implement an update() method in your handler to process
  # what was sent over the websocket stream
  def update(stream)
    ticker = stream.book_ticker
    @channel.send(ticker)
  end
end

# loop forever -- CTRL-C to break out in terminal
loop do
  puts "starting book ticker listener"
  client = Binance::Websocket.new("", "", Binance::Service::Us)
  listener = client.all_book_tickers(BookTickerHandler, 30.seconds)

  # Whenever the websocket stream is closed or errors out, we
  # restart it.  We passed 30.seconds to the listener when instantiating it
  # indicating that if no data is received in 30 seconds, force-close the
  # websocket stream.  The infinite looping here reopens the stream indefinitely.
  if reason = listener.run
    break if reason[:status] == "UNHANDLED"
    sleep(30.seconds) if reason[:status] == "ERROR"
    sleep(5.seconds) if reason[:status] == "CLOSED"
  else
    puts "No reason returned from listener"
  end
end

puts "book ticker listener stopped..."