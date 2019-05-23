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
    getter filters : Array(Binance::Responses::ExchangeFilter) = [] of Binance::Responses::ExchangeFilter

    {% for name in ORDER_TYPES %}
      def {{name.id.downcase}}_orders?
        @order_types.includes? "{{name.id}}"
      end
    {% end %}

  end
end