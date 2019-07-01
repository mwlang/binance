# Binance

This is an unofficial Crystal wrapper for the Binance exchange REST and WebSocket APIs.

## Features

Current

  * Basic implementation of REST API
    * Easy to use authentication
    * Methods return `Binance::Responses::ServerResponse` objects with JSON already deserialized
    * No need to generate signatures

Coming Soon!

  * Basic implementation of WebSocket API
    * Pass procs or lambdas to event handlers
    * Single and multiple streams supported

## COMPLETED REST Endpoints
  
### PUBLIC (NONE)
  * ping
  * time
  * exchangeInfo
  * depth (order book)
  * trades
  * aggTrades
  * klines
  * avgPrice
  * ticker/24hr
  * ticker/price
  * ticker/bookTicker

### MARKET_DATA (API_KEY required)
  * historicalTrades

### SIGNED (API_KEY and signed with SECRET_KEY required)
  * account
  * GET order (query)
  * GET openOrders

## TODO REST Endpoints

### SIGNED (API_KEY and signed with SECRET_KEY required)
  * POST order (new order)
  * POST order/test (test new order)
  * DELETE order (cancel order)
  * GET allOrders
  * myTrades

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     binance:
       github: mwlang/binance
   ```

2. Run `shards install`

## Getting Started

```crystal
require "binance"
```

### REST client

Create a new instance of the REST client:

```crystal
# If you only plan on touching public API endpoints, you can forgo any arguments
client = Binance::REST.new

# Otherwise provide an api_key and secret_key as keyword arguments
client = Binance::REST.new api_key: "x", secret_key: "y"
```

```crystal
# Ping the server
client.ping # => {}

# Get kline data
client.klines symbol: 'NEOETH', interval: '1m', limit: 1
# => [[1511682480000, "0.08230000", "0.08230000", "0.08230000", "0.08230000", "0.00000000", 
# 1511682539999, "0.00000000", 0, "0.00000000", "0.00000000", "2885926.46000000"]]

# Create an order
client.create_order! symbol: 'XRPETH', side: 'BUY', type: 'LIMIT', 
  time_in_force: 'GTC', quantity: '100.00000000', price: '0.00055000'
# => {"symbol"=>"XRPETH", "orderId"=>918248, "clientOrderId"=>"kmUU0i6cMWzq1NElE6ZTdu", 
# "transactTime"=>1511685028420, "price"=>"0.00055000", "origQty"=>"100.00000000", 
# "executedQty"=>"100.00000000", "status"=>"FILLED", "timeInForce"=>"GTC", "type"=>"LIMIT", 
# "side"=>"BUY"}

# Get deposit address
client.deposit_address asset: 'NEO'
# => {"address"=>"AHXeTWYv8qZQhQ2WNrBza9LHyzdZtFnbaT", "success"=>true, "addressTag"=>"", "asset"=>"NEO"}
```

## Testing

Testing is done primarily with webmock and stubbing server responses.  To make testing
easier, a mini-[VCR style record and playback](https://github.com/vcr/vcr) set of helpers
was implemented.  

However, only PUBLIC API VCR cassettes are committed to the repo.  To test SIGNED/VERIFIED
API calls, you'll have to setup your private API credentials.

TODO: extend the VCR functionality to obsfucate SIGNED calls to avoid revealing api keys.

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/mwlang/binance/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [mwlang](https://github.com/mwlang) - creator and maintainer
