module Binance
  class Listener
    getter symbols : Array(String)
    getter stream_name : String
    getter handlers : Hash(String, Binance::Handler)
    property messages : Int32 = 0

    record ChannelMessage, json : String
    record ChannelError, error : Exception
    record ChannelClose, message : String

    def initialize(@symbols : Array(String), @stream_name : String, handler_class)
      @channel = Channel(ChannelMessage | ChannelClose | ChannelError).new
      @handlers = {} of String => Binance::Handler
      @symbols.each do |symbol|
        @handlers[symbol.upcase] = handler_class.new(symbol)
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
        puts "#{stream_names} #{Time.utc.to_s}: Processed #{@messages.to_s} messages"
        @ws.pong
      end
    end

    def stream_names
      @symbols.map{|s| "#{s.downcase}@#{stream_name}"}.join("/")
    end

    def symbols_param
      @symbols.join(",").downcase
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

    def message_stream(message : ChannelMessage)
      Binance::Responses::Websocket::Stream.from_json(message.json)
    end

    def run
      open_connection

      while message = @channel.receive?
        case message

        when ChannelMessage
          stream = message_stream(message)
          handler = @handlers[stream.symbol]
          handler.messages += 1
          handler.update stream

        when ChannelClose
          puts "CLOSED #{symbols_param}"
          return {status: "CLOSED", message: symbols_param}

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