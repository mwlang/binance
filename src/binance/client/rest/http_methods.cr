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

    def public_{{method.id}}(url, params : HTTP::Params)
      connection = Cossack::Client.new(BASE_URL) do |client|
        client.headers["Content-Type"] = "application/json"
        client.headers["Accept"] = "application/json"
      end
      http_{{method.id}} connection, url, params
    end

    def verified_{{method.id}}(url, params : HTTP::Params)
      raise "No API KEY assigned" if api_key.to_s.blank?
      connection = Cossack::Client.new(BASE_URL) do |client|
        client.headers["Content-Type"] = "application/json"
        client.headers["Accept"] = "application/json"
        client.headers["X-MBX-APIKEY"] = api_key
      end
      http_{{method.id}} connection, url, params
    end

    def signed_{{method.id}}(url, params : HTTP::Params)
      raise "No API KEY assigned" if api_key.to_s.blank?
      raise "No API SECRET assigned" if api_secret.to_s.blank?
      connection = Cossack::Client.new(BASE_URL) do |client|
        client.headers["Content-Type"] = "application/json"
        client.headers["Accept"] = "application/json"
        client.headers["X-MBX-APIKEY"] = api_key
      end
      params["timestamp"] = Time.utc.to_unix_ms.to_s
      params["signature"] = hmac to_query(params)

      http_{{method.id}} connection, url, params
    end

  {% end %}
end
