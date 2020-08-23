module Binance
  class Listener
    getter symbols : Array(String)
    getter stream_name : String
    getter handlers : Hash(String, Binance::Handler)
    property messages : Int32 = 0

    record ChannelMessage, json : String
    record ChannelError, error : Exception
    record ChannelClose, message : String

    def initialize(@symbols : Array(String), @stream_name : String)
      @channel = Channel(ChannelMessage | ChannelClose | ChannelError).new
      @handlers = {} of String => Binance::Handler
      @symbols.each do |symbol|
        @handlers[symbol.upcase] = Binance::Handler.new(symbol)
      end

      host = "stream.binance.com"
      path = "/stream?streams=#{stream_names}"
      port = 9443
      puts "opening #{symbols_param}"
      @ws = HTTP::WebSocket.new host, path, port, tls: true

      @ws.on_message do |message|
        @messages += 1
        @channel.send ChannelMessage.new(message)
      end

      @ws.on_close do |code, message|
        puts "Closed: #{message}"
        @channel.send ChannelClose.new(message)
      end

      @ws.on_ping do |message|
        puts "TICKERS #{Time.utc.to_s}: Processed #{@messages.to_s} messages"
        @ws.pong
      end
    end

    def stream_names
      @symbols.map{|s| "#{s.downcase}@#{stream_name}"}.join("/")
    end

    def symbols_param
      @symbols.join(",").downcase
    end

    def extract_json(message)
      JSON.parse(message)
    rescue ex : JSON::ParseException
      @channel.send ChannelError.new(ex)
      return nil
    end

    def open_connection
      puts "opening ws connection"
      spawn do
        begin
          @ws.run 
        rescue ex : OpenSSL::SSL::Error
          @channel.send ChannelError.new(ex)
        end
      end
    end

    def close_connection
      puts "closing connection"
      @ws.close unless @ws.closed?
    end

    def reopen_connection
      puts "reopening ws connection"
      close_connection
      sleep(5)
      open_connection
    end

    def run
      open_connection

      while message = @channel.receive?
        case message

        when ChannelClose
          puts "CLOSED #{symbols_param}"
          return {status: "CLOSED", message: symbols_param}

        when ChannelMessage
          if json = extract_json(message.json)
            @handlers[json["data"]["s"]].update json["data"]
          end

        when ChannelError
          puts message.error.message
          return {status: "ERROR", message: message.error.message}

        else
          return {status: "UNHANDLED", message: message.inspect}
        end
      end
    end
  end
end