def cassette_filepath(service, name : String)
  File.expand_path("./spec/fixtures/vcr_cassettes/#{service_folder(service)}/#{name}.yml")
end

def cassette_exists?(service, name : String)
  File.exists? cassette_filepath(service, name)
end

def with_vcr_cassette(service : Binance::Service, name : String, &block)
  WebMock.wrap do
    if cassette_exists? service, name
      ts = playback_cassette service, name
      Timecop.freeze(ts) { block.call }
    else
      Timecop.freeze(Time.utc) do
        record_cassette service, name
        block.call
      end
    end
  end
end

def with_vcr_cassette(name : String, &block)
  with_vcr_cassette(Binance::Service::Com, name, &block)
end

def service_folder(service : Binance::Service)
  case service
  when Binance::Service::Com then "binance.com"
  when Binance::Service::Us then "binance.us"
  else raise "Unknown service #{service.inspect}"
  end
end

def playback_cassette(service, name : String)
  cassette = YAML.parse(File.read(cassette_filepath(service, name)))

  full_uri = if cassette["request"]["query_params"]?
               "#{cassette["request"]["uri"]}?#{cassette["request"]["query_params"]}"
             else
               "#{cassette["request"]["uri"]}"
             end

  method = cassette["request"]["method"]? ? cassette["request"]["method"].as_s : "GET"
  status = cassette["response"]["status"]? ? cassette["response"]["status"].as_i : 400
  body = cassette["response"]["body"].as_s

  WebMock.stub(method, full_uri).to_return(body: body, status: status)
  cassette["request"]["timestamp"]? ? Time.unix_ms(cassette["request"]["timestamp"].as_i64) : Time.utc
end

def record_cassette(service, name : String)
  WebMock.callbacks.add do
    after_live_request do |request, response|
      uri = "#{request.scheme}://#{request.headers["Host"]}#{request.resource.split("?")[0]}"
      if io = response.body_io?
        response.consume_body_io
      end
      data = {
        request: {
          method:       request.method,
          uri:          uri,
          body:         request.body.to_s,
          query_params: request.query_params.to_s,
          headers:      request.headers,
          timestamp:    Time.utc.to_unix_ms,
        },
        response: {
          status: response.status_code,
          body:   response.body,
        },
      }
      pp! response
      puts "*" * 80
      pp! response.body
      puts "*" * 80
      File.open(cassette_filepath(service, name), "w") { |f| YAML.dump(data, f) }
    end
  end
  WebMock.allow_net_connect = true
end
