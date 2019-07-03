require "../src/binance"
require "../spec/support/api_key"

# SEE README for setting up a "../spec/test.yml" with your own API keys

signed_client = Binance::REST.new(api_key: api_key, secret_key: api_secret)

symbol = "BNBUSDC"
current_price = signed_client.price(symbol).tickers[0].price

puts "current price for #{symbol} is %0.6f" % current_price

puts "placing limit SELL order..."

response = signed_client.new_order(
  symbol: symbol,
  side: "SELL", 
  order_type: "LIMIT", 
  time_in_force: "GTC", 
  quantity: 1.0, 
  price: (current_price * 1.1).round(4)
)

puts "Order placed successfully? #{response.success}"

if response.success
  order = response.orders[0]
  puts "Order #{order.order_id} placed.  Status: #{order.status}"
  puts "canceling the order..."
  response = signed_client.cancel_order(
    symbol: symbol,
    order_id: order.order_id
  )
  if response.success
    puts "order cancelled successfully"
  else
    puts "order was NOT canceled!"
    puts "#{response.error_code}: #{response.error_message}"
  end
else
  puts "#{response.error_code}: #{response.error_message}"
end

puts "That's all folks!"
