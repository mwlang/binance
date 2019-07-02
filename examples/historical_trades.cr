require "../src/binance"

api_key = "vmPUZE6mv9SD5VNHk4HlWFsOr6aKE2zvsw0MuIgwCIPy6utIco14y7Ju91duEh8A"
api_secret = "NhqPtmdSJYdKjVHjA7PZj4Mge3R5YNiP1e3UZjInClVN65XAbvqqM6A7H5fATj0j"

signed_client = Binance::REST.new(api_key: api_key, secret_key: api_secret)
signed_client.historical_trades("BTCUSDC", 5).trades.each do |trade|
  puts "#{trade.time} #{"%0.6f" % trade.price} #{"%0.6f" % trade.quantity}"
end

# => 
# 2019-07-02 16:08:07 UTC 10465.560000 0.001689
# 2019-07-02 16:08:09 UTC 10465.650000 1.000000
# 2019-07-02 16:08:09 UTC 10465.650000 0.034570
# 2019-07-02 16:08:09 UTC 10465.650000 0.017813
# 2019-07-02 16:08:09 UTC 10471.390000 0.049130
