module Binance::Responses
  class ExchangeSymbol
    include JSON::Serializable

    @[JSON::Field(key: "symbol")]
    getter symbol : String = ""

    @[JSON::Field(key: "status")]
    getter status : String = ""

    @[JSON::Field(key: "baseAsset")]
    getter base_asset : String = ""

    @[JSON::Field(key: "baseAssetPrecision")]
    getter base_asset_precision : Int32 = 8

    @[JSON::Field(key: "quoteAsset")]
    getter quote_asset : String = ""

    @[JSON::Field(key: "quoteAssetPrecision")]
    getter quote_asset_precision : Int32 = 8

    @[JSON::Field(key: "orderTypes")]
    getter order_types : Array(String) = [] of String

    @[JSON::Field(key: "icebergAllowed")]
    getter iceberg_allowed : Bool = false

    @[JSON::Field(key: "isSpotTradingAllowed")]
    getter spot_trading_allowed : Bool = false

    @[JSON::Field(key: "isMarginTradingAllowed")]
    getter margin_trading_allowed : Bool = false

    @[JSON::Field(key: "filters", converter: Binance::Converters::ToFilter)]
    getter filters : Array(ExchangeFilter) = [] of Binance::Responses::ExchangeFilter

    private def find_or_initialize(filter_class : ExchangeFilter.class)
      filters.select(filter_class).first? || filter_class.new
    end

    @[JSON::Field(ignore: true)]
    @price_filter : PriceFilter?

    def price_filter : PriceFilter
      @price_filter ||= find_or_initialize(PriceFilter)
    end

    delegate :tick_size, :min_price, :max_price, to: :price_filter

    @[JSON::Field(ignore: true)]
    @percent_price_filter : PercentPriceFilter?

    def percent_price_filter : PercentPriceFilter
      @percent_price_filter ||= find_or_initialize(PercentPriceFilter)
    end
    delegate :multiplier_up, :multiplier_down, :avg_price_mins, to: :percent_price_filter

    @[JSON::Field(ignore: true)]
    @lot_size_filter : LotSizeFilter?

    def lot_size_filter : LotSizeFilter
      @lot_size_filter ||= find_or_initialize(LotSizeFilter)
    end

    @[JSON::Field(ignore: true)]
    @min_notional_filter : MinNotionalFilter?

    def min_notional_filter : MinNotionalFilter
      @min_notional_filter ||= find_or_initialize(MinNotionalFilter)
    end
    delegate :min_notional, :apply_to_market, :avg_price_mins, to: :min_notional_filter

    @[JSON::Field(ignore: true)]
    @iceberg_parts_filter : IcebergPartsFilter?

    def iceberg_parts_filter : IcebergPartsFilter
      @iceberg_parts_filter ||= find_or_initialize(IcebergPartsFilter)
    end

    @[JSON::Field(ignore: true)]
    @market_lot_size_filter : MarketLotSizeFilter?

    def market_lot_size_filter : MarketLotSizeFilter
      @market_lot_size_filter ||= find_or_initialize(MarketLotSizeFilter)
    end
    delegate :min_quantity, :max_quantity, :step_size, to: :market_lot_size_filter

    @[JSON::Field(ignore: true)]
    @max_num_algo_orders_filter : MaxNumAlgoOrdersFilter?
    delegate :max_num_algo_orders, to: :max_num_algo_orders_filter

    def max_num_algo_orders_filter : MaxNumAlgoOrdersFilter
      @max_num_algo_orders_filter ||= find_or_initialize(MaxNumAlgoOrdersFilter)
    end

    {% for name in ORDER_TYPES %}
      def {{name.id.downcase}}_orders?
        @order_types.includes? "{{name.id}}"
      end
    {% end %}
  end
end
