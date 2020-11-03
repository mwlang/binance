require "../src/binance"

client = Binance::Websocket.new

# Each market will instantiate it's own KlineHandler
class KlineHandler < Binance::Handler

  # implement an update() method in your handler to process
  # what was sent over the websocket stream
  def update(stream)
    kline = stream.kline
    puts [
      kline.symbol,
      "messages: #{messages}",
      "interval: #{kline.candle.interval}",
      "closed?: #{kline.candle.closed}",
      "open: %0.6f" % kline.candle.open_price,
      "high: %0.6f" % kline.candle.high_price,
      "low: %0.3f" % kline.candle.low_price,
      "close: %0.6f" % kline.candle.close_price,
    ].join(" ")
  end
end

puts "starting kline listener"

listener = Binance::Listener.new ["BTCUSDT"], "kline_1m", KlineHandler

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

puts "kline listener stopped..."