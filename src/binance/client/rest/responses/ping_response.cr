module Binance::Responses
  # Example Server Response:
  #     {}
  class PingResponse < Responses::ServerResponse
    def pong
      (r = response) && r.is_a?(Cossack::Response) ? r.body == "{}" : false
    end
  end
end