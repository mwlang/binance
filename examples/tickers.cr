require "../src/binance"

client = Binance::REST.new

response = client.twenty_four_hour
puts "WEIGHT %i" % response.used_weight
puts "TICKERS %i" % response.tickers.size

response.tickers[0,5].each do |ticker|
  puts [
      ticker.symbol,
      "bid: %0.6f" % ticker.bid_price,
      "ask: %0.6f" % ticker.ask_price,
      "change: %0.3f" % ticker.price_change_percent,
      "high: %0.6f" % ticker.high_price,
      "low: %0.6f" % ticker.low_price
    ].join(" ")
end
