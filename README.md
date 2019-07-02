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

## REST Endpoints
  
### PUBLIC (NONE)
  * [ping](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#test-connectivity) Test connectivity to the Rest API.
  * [time](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#check-server-time) Test connectivity to the Rest API and get the current server time.
  * [exchangeInfo](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#exchange-information) Current exchange trading rules and symbol information
  * [depth (order book)](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#order-book) Get Order book depth info.
  * [trades](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#recent-trades-list) Get recent trades (up to last 500).
  * [aggTrades](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#compressedaggregate-trades-list) Get compressed, aggregate trades.
  * [klines](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#klinecandlestick-data) Kline/candlestick bars for a symbol. Klines are uniquely identified by their open time.
  * [avgPrice](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#current-average-price) Current average price for a symbol.
  * [ticker/24hr](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#24hr-ticker-price-change-statistics) 24 hour rolling window price change statistics.
  * [ticker/price](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#symbol-price-ticker) Latest price for a symbol or symbols.
  * [ticker/bookTicker](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#symbol-order-book-ticker) Best price/qty on the order book for a symbol or symbols.

### MARKET_DATA (API_KEY required)
  * [historicalTrades](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#old-trade-lookup-market_data) Get older trades.

### SIGNED (API_KEY and signed with SECRET_KEY required)
  * [account](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#account-information-user_data) Get current account information.
  * [GET order (query)](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#query-order-user_data) Check an order's status.
  * [GET openOrders](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#current-open-orders-user_data) Get all open orders on a symbol.
  * [GET allOrders](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#all-orders-user_data) Get all account orders; active, canceled, or filled.
  * TODO: [POST order (new order)](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#new-order--trade) Send in a new order.
  * TODO: [POST order/test (test new order)](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#test-new-order-trade) Creates and validates a new order but does not send it into the matching engine.
  * TODO: [DELETE order (cancel order)](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#cancel-order-trade) Cancel an active order.
  * TODO: [myTrades](https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md#account-trade-list-user_data) Get trades for a specific account and symbol.

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

#### Anatomy of a `Binance::Responses::ServerResponse`

Every API endpoint call results in a ServerResponse that deserializes the JSON data retrieved from the server.

A ServerResponse is either a successful call and loaded with data or in an error state.  Exceptions
from connection fails or the server returning error codes are captured.  It is up to you to check
for errors before attempting to access the properties of the ~~~ServerResponses~~~


```crystal
# Ping the server
client.ping.pong? # => true

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

All API's are TDD and have specs.  If you find a bug or want to contribute, then your 
contributions is expected to have specs exercising your code changes.

API calls are captured with so-called VCR cassettes, which is a [small library](https://github.com/mwlang/binance/blob/master/spec/support/vcr.cr) built upon Webmock for capturing and playing back a server interaction with one caveat:  signed APIs (those requiring API key) are not checked
into the repository.  As a consequence, you'll have to set up your API key and record your own
cassettes locally to get specs passing.  Signed exchanges are necessarily kept somewhat generic, but read the specs for prerequisites to actions you much take on Binance manually to prepare
to capture your signed cassettes. 

NOTE: Signed exchanges are saved to ./spec/fixtures/vcr_cassettes/signed and this folder is excluded in the .gitignore file.

To set up your API key for test environment, rename ./spec/test.yml.example to ./spec/test.yml
and replace values in the file with your own API key.  This file is likewise excluded via .gitignore.

From time to time, Binance silently releases changes to their API, adding new and undocumented fields.  For example, the ```account``` api presently returns a accountType with value "MARGIN",
but this field is not yet documented nor are the ENUM values known at this time.  When noticed,
these fields may be added and parsed without issue.

## Contributing

1. Fork it (<https://github.com/mwlang/binance/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [mwlang](https://github.com/mwlang) - creator and maintainer
