require "http"
require "json"
require "yaml"
require "openssl/hmac"

# ## Terminology
# * `base asset` refers to the asset that is the `quantity` of a symbol.
# * `quote asset` refers to the asset that is the `price` of a symbol.
#
module Binance
  enum Service
    Com
    Us
  end

  # **Symbol status (status):**
  #
  # * PRE_TRADING
  # * TRADING
  # * POST_TRADING
  # * END_OF_DAY
  # * HALT
  # * AUCTION_MATCH
  # * BREAK
  #
  SYMBOL_STATUSES = %w{PRE_TRADING TRADING POST_TRADING END_OF_DAY HALT AUCTION_MATCH BREAK}

  # **Symbol type:**
  #
  # * SPOT
  #
  SYMBOL_TYPES = %w{SPOT}

  # **Order types (orderTypes, type):**
  #
  # * LIMIT
  # * MARKET
  # * STOP_LOSS
  # * STOP_LOSS_LIMIT
  # * TAKE_PROFIT
  # * TAKE_PROFIT_LIMIT
  # * LIMIT_MAKER
  #
  ORDER_TYPES = %w{LIMIT MARKET STOP_LOSS STOP_LOSS_LIMIT TAKE_PROFIT TAKE_PROFIT_LIMIT LIMIT_MAKER}

  # **Order status (status):**
  #
  # * NEW
  # * PARTIALLY_FILLED
  # * FILLED
  # * CANCELED
  # * PENDING_CANCEL (currently unused)
  # * REJECTED
  # * EXPIRED
  #
  ORDER_STATUSES = %w{NEW PARTIALLY_FILLED FILLED CANCELED PENDING_CANCEL REJECTED EXPIRED}

  # **Order side (side):**
  #
  # * BUY
  # * SELL
  #
  ORDER_SIDES = %w{BUY SELL}

  # **Time in force (timeInForce):**
  #
  # * GTC
  # * IOC
  # * FOK
  #
  TIME_IN_FORCES = %w{GTC IOC FOK}

  # **Kline/Candlestick chart intervals:**
  #
  # m -&gt; minutes; h -&gt; hours; d -&gt; days; w -&gt; weeks; M -&gt; months
  #
  # * 1m
  # * 3m
  # * 5m
  # * 15m
  # * 30m
  # * 1h
  # * 2h
  # * 4h
  # * 6h
  # * 8h
  # * 12h
  # * 1d
  # * 3d
  # * 1w
  # * 1M
  #
  KLINE_INTERVALS = %w{1m 3m 5m 15m 30m 1h 2h 4h 6h 8h 12h 1d 3d 1w 1M}

  # **Rate limit intervals (interval)**
  #
  # * SECOND
  # * MINUTE
  # * DAY
  #
  RATE_LIMIT_INTERVALS = %w{SECOND MINUTE DAY}
end

require "./binance/responses/*"
require "./binance/converters/*"
require "./binance/client/rest"
require "./binance/client/websocket"
