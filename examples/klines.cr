require "../src/binance"

client = Binance::REST.new

client.klines(symbol: "BNBBTC", interval: "5m", limit: 5).klines.each do |kline|
  puts "#{kline.open_time} O: #{"%0.6f" % kline.open_price} C: #{"%0.6f" % kline.close_price}"
end
