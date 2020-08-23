module Binance
  class Handler
    getter symbol : String
    property messages : Int32 = 0

    def initialize(@symbol : String)
    end

    def extract_json(message)
      JSON.parse(message)
    rescue ex : JSON::ParseException
      @channel.send ChannelError.new(ex)
      return nil
    end


    def run
      open_connection

      while message = @channel.receive?
        case message

        when ChannelClose
          puts "CLOSED #{symbols_param}"
          reopen_connection

        when ChannelMessage
          if json = extract_json(message.json)
            @tickers[json["data"]["s"]].update json["data"]
          end

        when ChannelError
          puts message.error.message
          reopen_connection

        else
          exit
        end
      end
    end
  end
end