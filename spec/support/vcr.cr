def cassette_filepath(name : String)
  File.expand_path("./spec/fixtures/vcr_cassettes/#{name}.yml")
end

def cassette_exists?(name : String)
  File.exists? cassette_filepath(name)
end

def with_vcr_cassette(name : String, &block)
  WebMock.wrap do
    if cassette_exists? name
      ts = playback_cassette name
      Timecop.freeze(ts) { block.call }
    else
      Timecop.freeze(Time.utc) do
        record_cassette name
        block.call
      end
    end
  end
end

def playback_cassette(name : String)
  cassette = YAML.parse(File.read(cassette_filepath(name)))

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

def record_cassette(name : String)
  WebMock.callbacks.add do
    after_live_request do |request, response|
      uri = "#{request.scheme}://#{request.headers["Host"]}#{request.resource.split("?")[0]}"
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

      File.open(cassette_filepath(name), "w") { |f| YAML.dump(data, f) }
    end
  end
  WebMock.allow_net_connect = true
end
