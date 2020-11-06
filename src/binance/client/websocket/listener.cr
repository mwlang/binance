module Binance
  # The Listener class is responsible for managing the websocket connection and passing all
  # messages to the Handler.  No parsing is done here.  The JSON of the message is passed as
  # a `String` object ready to be parsed.
  #
  # Binance's websocket service ocassionally goes quiet with no updates and without closing
  # the websocket stream.  Because of this, the `Listener` class implements a watcher in
  # another thread that will periodically check to see if data is still flowing.  If not,
  # the websocket stream is closed.  Any of your handlers that are processing data and
  # running in a `Fiber` on a timed-loop should also check the Handler's `stopped`
  # property to see if the `Listener`'s websocket stream has closed.
  #
  class Listener
    getter symbols : Array(String)
    getter timeout : Time::Span
    getter last_seen : Time = Time.utc
    getter stream_name : String
    getter handlers : Hash(String, Binance::Handler)
    property messages : Int32 = 0
    property stopped : Bool = false

    record ChannelMessage, json : String
    record ChannelError, error : Exception
    record ChannelClose, message : String

    # If the listener is started with a timeout > 0, then the
    # watcher will close the websocket connection if no messages
    # from the server is received within the timeout span.
    def start_watcher(ws)
      return if @timeout == 0.seconds
      spawn do
        loop do
          sleep(1.second)
          break if @stopped || (Time.utc - last_seen) > timeout
        end
        @stopped = true
        handlers.values.each{|h| h.stopped = true}
        ws.close
      end
    end

    # One handler for each market/symbol is instantiated.
    # If a timeout > 0.seconds is given, then a watcher loop is
    # started and will force close the websocket stream if data
    # stops flowing for longer than the given timeout span.
    def initialize(
      @symbols : Array(String),
      @stream_name : String,
      handler_class,
      @timeout : Time::Span = 0.seconds
    )
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
        @last_seen = Time.utc
        @messages += 1
        @channel.send ChannelMessage.new(message)
      end

      @ws.on_close do |code, message|
        @last_seen = Time.utc
        @stopped = true
        puts "Closed: #{message}"
        @channel.send ChannelClose.new(message)
      end

      @ws.on_ping do |message|
        @last_seen = Time.utc
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
          start_watcher(@ws)
          @ws.run
        rescue ex : OpenSSL::SSL::Error
          @stopped = true
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
          handlers.values.each{|h| h.stopped = true}
          return {status: "CLOSED", message: symbols_param}

        when ChannelError
          puts message.error.message
          handlers.values.each{|h| h.stopped = true}
          return {status: "ERROR", message: message.error.message}

        else
          handlers.values.each{|h| h.stopped = true}
          return {status: "UNHANDLED", message: message.inspect}
        end
      end
    end
  end
end