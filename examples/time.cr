require "../src/binance"

client = Binance::REST.new

puts client.time.server_time.inspect
