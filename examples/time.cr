require "../src/binance"

client = Binance::REST.new

puts client.time.body
puts client.time.server_time.inspect
puts client.time.used_weight.inspect
