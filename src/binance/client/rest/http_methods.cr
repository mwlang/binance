module Binance::HttpMethods
  BASE_URL = "https://api.binance.com/api"

  def to_query(params)
    params.map { |k, v| "#{k.to_s}=#{v.to_s}" }.join("&")
  end

  {% for method in %w(get post delete) %}

    def http_{{method.id}}(connection, url, params)
      url_with_params = "#{url}?#{to_query(params)}"
      connection.{{method.id}} url_with_params
    end

    def public_connection
      @public_connection ||= Cossack::Client.new(BASE_URL) do |client|
        client.headers["Content-Type"] = "application/json"
        client.headers["Accept"] = "application/json"
      end
    end

    def connection_with_api_key
      @connection_with_api_key ||= Cossack::Client.new(BASE_URL) do |client|
        client.headers["Content-Type"] = "application/json"
        client.headers["Accept"] = "application/json"
        client.headers["X-MBX-APIKEY"] = api_key
      end
    end

    def public_{{method.id}}(url, params : HTTP::Params)
      http_{{method.id}} public_connection, url, params
    end

    def verified_{{method.id}}(url, params : HTTP::Params)
      raise "No API KEY assigned" if api_key.to_s.blank?

      http_{{method.id}} connection_with_api_key, url, params
    end

    def signed_{{method.id}}(url, params : HTTP::Params)
      raise "No API KEY assigned" if api_key.to_s.blank?
      raise "No API SECRET assigned" if secret_key.to_s.blank?

      params["timestamp"] = Time.utc.to_unix_ms.to_s
      params["signature"] = hmac to_query(params)

      http_{{method.id}} connection_with_api_key, url, params
    end

  {% end %}
end
