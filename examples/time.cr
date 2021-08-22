require "../src/binance"

puts "binance.com..."
client = Binance::REST.new("", "", Binance::Service::Com)

puts client.time.body
puts client.time.server_time.inspect
puts client.time.used_weight.inspect

puts "binance.us..."
client = Binance::REST.new("", "", Binance::Service::Us)

puts client.time.body
puts client.time.server_time.inspect
puts client.time.used_weight.inspect
