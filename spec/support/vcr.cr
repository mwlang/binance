def cassette_filepath(name : String)
  File.expand_path("./spec/fixtures/vcr_cassettes/#{name}.yml")
end

def cassette_exists?(name : String)
  File.exists? cassette_filepath(name)
end

def with_vcr_cassette(name : String)
  WebMock.wrap do
    if cassette_exists? name
      playback_cassette name
    else
      record_cassette name
    end

    yield
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
end

def record_cassette(name : String)
  WebMock.callbacks.add do
    after_live_request do |request, response|

      data = {
        request: {
          method: request.method,
          uri: request.resource.split("?")[0],
          body: request.body.to_s,
          query_params: request.query_params.to_s,
          headers: request.headers,
        },
        response: {
          status: response.status_code,
          body: response.body,
        }
      }

      File.open(cassette_filepath(name), "w") { |f| YAML.dump(data, f) }
    end
  end
  WebMock.allow_net_connect = true
end
