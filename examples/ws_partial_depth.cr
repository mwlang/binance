require "../src/binance"
require "colorize"

# Each market will instantiate it's own TickerHandler
class PartialDepthHandler < Binance::Handler

  def clear_screen
    print "\e[" + "2J"
  end

  # implement an update() method in your handler to process
  # what was sent over the websocket stream
  def update(stream)
    ob = stream.partial_depth
    clear_screen
    puts "=" * 45
    puts ["BIDS <<", ob.symbol, ob.last_update_id, " >> ASKS"].join(" ").rjust(40)
    puts "=" * 45
    ob.bids.each_with_index do |bid, index|
      bid_price = ("%0.2f" % bid.price)
      bid_qty = ("%0.6f" % bid.quantity)

      ask_price = ("%0.2f" % ob.asks[index].price)
      ask_qty = ("%0.6f" % ob.asks[index].quantity)
      puts [
        bid_price.ljust(10).colorize.red,
        bid_qty.rjust(10).colorize.red,
        " | ",
        ask_price.ljust(10).colorize.green,
        ask_qty.rjust(10).colorize.green
      ].join("")
    end
  end
end

puts "starting partial depth listener"

client = Binance::Websocket.new

# loop forever -- CTRL-C to break out in terminal
loop do

  # will restart the websocket stream if 30 seconds lapses without new data arriving
  listener = Binance::Listener.new ["BTCUSDT"], "depth20", PartialDepthHandler

  if reason = listener.run
    break if reason[:status] == "UNHANDLED"
    sleep(30.seconds) if reason[:status] == "ERROR"
    sleep(5.seconds) if reason[:status] == "CLOSED"
  else
    puts "No reason returned from listener"
  end
end

puts "listener stopped..."