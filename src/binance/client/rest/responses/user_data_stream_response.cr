module Binance::Responses
  # Typical Server Response:
  #     {
  #       "listenKey": "pqia91ma19a5s61cv6a81va65sdf19v8a65a1a5s61cv6a81va65sdf19v8a65a1"
  #     }
  class UserDataStreamResponse < Responses::ServerResponse
    @[JSON::Field(key: "listenKey")]
    getter listen_key : String = ""
  end
end
