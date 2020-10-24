require "../src/binance"

# Each market will instantiate it's own TickerHandler
class BookTickerHandler < Binance::Handler

  def initialize(@symbol : String)
    super(@symbol)
    @channel = Channel(Binance::Responses::Websocket::BookTicker).new
    @ticks = Array(Binance::Responses::Websocket::BookTicker).new
    @mutex = Mutex.new
    start_aggregator
  end

  def collect_tickers
    spawn do
      loop do
        ticker = @channel.receive
        @mutex.synchronize { @ticks << ticker }
      end
    end
  end

  def aggregate_tickers
    spawn do
      loop do
        sleep(3.seconds)
        @mutex.synchronize do
          count = @ticks.size
          sum_bids = 0.0
          sum_bids_quantity = 0.0
          sum_asks = 0.0
          sum_asks_quantity = 0.0
          @ticks.each do |tick|
            sum_bids += tick.bid_price
            sum_bids_quantity += tick.bid_quantity
            sum_asks += tick.ask_price
            sum_asks_quantity += tick.ask_quantity
          end
          ab = (sum_bids / count)
          aa = (sum_asks / count)
          mp = (ab + aa) / 2.0
          vb = (sum_bids_quantity / count)
          va = (sum_asks_quantity / count)
          vi = (vb - va) / (vb + va)
          pressure = "neutral"
          pressure = "sell   " if vi < -0.33
          pressure = "buy    " if vi > 0.33
          puts [
            "pressure: %s" % pressure,
            "imbalance: %0.2f" % vi,
            "mid_price: %0.6f" % mp,
            "bid: %0.6f" % ab,
            "bid qty: %0.6f" % vb,
            "ask: %0.6f" % aa,
            "ask qty: %0.6f" % va,
            "count: #{count}",
          ].join(" ")
          @ticks.clear
        end
      end
    end
  end

  def start_aggregator
    collect_tickers
    aggregate_tickers
  end

  # implement an update() method in your handler to process
  # what was sent over the websocket stream
  def update(stream)
    ticker = stream.book_ticker
    @channel.send(ticker)
  end
end

client = Binance::Websocket.new
listener = client.book_ticker(["BTCUSDT"], BookTickerHandler)

puts "starting book ticker listener"

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

puts "book ticker listener stopped..."