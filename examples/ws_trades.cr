require "../src/binance"
require "colorize"

# If isBuyerMaker is true for the trade, it means that the order of whoever was
# on the buy side, was sitting as a bid in the orderbook for some time (so that
# it was making the market) and then someone came in and matched it immediately
# (market taker). So, that specific trade will now qualify as SELL and in UI
# highlight as redish. On the opposite isBuyerMaker=false trade will qualify as
# BUY and highlight greenish.


# Each market will instantiate it's own TickerHandler
class TradesHandler < Binance::Handler

  # implement an update() method in your handler to process
  # what was sent over the websocket stream
  def update(stream)
    trade = stream.trade
    line = [
      ("%0.2f" % trade.price).rjust(10),
      ("%0.6f" % trade.quote_quantity).rjust(10),
    ].join(" ")
    puts trade.is_buyer_maker ? line.colorize.red : line.colorize.green
  end
end

puts "starting trades listener"

client = Binance::Websocket.new

# loop forever -- CTRL-C to break out in terminal
loop do

  # will restart the websocket stream if 30 seconds lapses without new data arriving
  listener = client.trade ["BTCUSDT"], TradesHandler, 30.seconds

  if reason = listener.run
    break if reason[:status] == "UNHANDLED"
    sleep(30.seconds) if reason[:status] == "ERROR"
    sleep(5.seconds) if reason[:status] == "CLOSED"
  else
    puts "No reason returned from listener"
  end
end

puts "ticker listener stopped..."