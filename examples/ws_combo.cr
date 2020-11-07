require "../src/binance"

# One Handler to rule 'em all!  This example shows how to have one handler and multiple
# symbols and streams.  The key difference is instantiating the handler vs. passing the
# class for the handler.
class ComboHandler < Binance::Handler

  # implement an update() method in your handler to process
  # what was sent over the websocket stream
  def update(stream)
    if stream.ticker?
      output_ticker(stream.ticker)
    elsif stream.book_ticker?
      output_book_ticker(stream.book_ticker)
    else
      pp! stream.data
    end
  end

  def output_ticker(ticker)
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

  def output_book_ticker(book_ticker)
    ab = book_ticker.bid_price
    aa = book_ticker.ask_price
    mp = (ab + aa) / 2.0
    vb = book_ticker.bid_quantity
    va = book_ticker.ask_quantity
    vi = (vb - va) / (vb + va)
    pressure = "neutral"
    pressure = "sell   " if vi < -0.33
    pressure = "buy    " if vi > 0.33
    puts [
      "pressure: %s" % pressure,
      "imbalance: %0.2f" % vi,
      "mid_price: %0.6f" % mp,
      "bid: %0.6f" % ab,
      "bid qty: %0.6f" % vb,
      "ask: %0.6f" % aa,
      "ask qty: %0.6f" % va,
    ].join(" ")
  end
end

puts "starting ticker listener"

# instantiating a handler allows us to use one handler for multiple streams
handler = ComboHandler.new
client = Binance::Websocket.new

# loop forever -- CTRL-C to break out in terminal
loop do

  # will restart the websocket stream if 30 seconds lapses without new data arriving
  # stream names are as named by binance, case-sensitive.
  listener = client.combo ["BTCUSDT", "BNBBTC"], ["ticker", "bookTicker", "miniTicker"], handler, 30.seconds

  if reason = listener.run
    break if reason[:status] == "UNHANDLED"
    sleep(30.seconds) if reason[:status] == "ERROR"
    sleep(5.seconds) if reason[:status] == "CLOSED"
  else
    puts "No reason returned from listener"
  end
end

puts "ticker listener stopped..."