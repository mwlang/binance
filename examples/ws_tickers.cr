require "../src/binance"

# Each market will instantiate it's own TickerHandler
class TickerHandler < Binance::Handler

  # implement an update() method in your handler to process
  # what was sent over the websocket stream
  def update(stream)
    ticker = stream.ticker
    puts [
      ticker.symbol,
      "messages: #{messages}",
      "bid: %0.6f" % ticker.bid_price,
      "ask: %0.6f" % ticker.ask_price,
      "change: %0.3f" % ticker.price_change_percent,
      "high: %0.6f" % ticker.high_price,
      "low: %0.6f" % ticker.low_price,
    ].join(" ")
  end
end

puts "starting ticker listener"

listener = Binance::Listener.new ["BTCUSDT", "BNBBTC"], "ticker", TickerHandler

# loop forever -- CTRL-C to break out in terminal
loop do
  if reason = listener.run
    break if reason[:status] == "UNHANDLED"
    sleep(30.seconds) if reason[:status] == "ERROR"
    sleep(5.seconds) if reason[:status] == "CLOSED"
  else
    puts "No reason returned from listener"
  end
end

puts "ticker listener stopped..."