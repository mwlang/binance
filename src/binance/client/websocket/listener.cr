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
    getter stream_names : String
    getter timeout : Time::Span
    getter last_seen : Time = Time.utc
    getter handlers : Hash(String, Binance::Handler)
    getter websocket : HTTP::WebSocket
    property messages : Int32 = 0
    property stopped : Bool = false

    record ChannelMessage, json : String
    record ChannelError, error : Exception
    record ChannelClose, message : String

    # If the listener is started with a timeout > 0, then the
    # watcher will close the websocket connection if no messages
    # from the server is received within the timeout span.
    def start_watcher
      return if timeout == 0.seconds
      spawn do
        loop do
          sleep(1.second)
          break if stopped || (Time.utc - last_seen) > timeout
        end
        @stopped = true
        handlers.values.each{|h| h.stopped = true}
        websocket.close
      end
    end

    SENTINEL = "SENTINEL"

    # Uses one handler for all market/symbols when an instantiated handler is passed
    # If a timeout > 0.seconds is given, then a watcher loop is
    # started and will force close the websocket stream if data
    # stops flowing for longer than the given timeout span.
    def initialize(
      @symbols : Array(String),
      streams : Array(String),
      handler : Binance::Handler,
      @timeout : Time::Span = 0.seconds
    )
      @stream_names = build_stream_names(streams)
      @channel = Channel(ChannelMessage | ChannelClose | ChannelError).new
      @handlers = {} of String => Binance::Handler
      @handlers[SENTINEL] = handler
      @websocket = open_connection
    end

    def initialize(
      symbol : String,
      streams : Array(String),
      handler : Binance::Handler,
      @timeout : Time::Span = 0.seconds
    )
      @symbols = [symbol]
      @stream_names = build_stream_names(streams)
      @channel = Channel(ChannelMessage | ChannelClose | ChannelError).new
      @handlers = {} of String => Binance::Handler
      @handlers[SENTINEL] = handler
      @websocket = open_connection
    end

    # One handler for each market/symbol is instantiated.
    # If a timeout > 0.seconds is given, then a watcher loop is
    # started and will force close the websocket stream if data
    # stops flowing for longer than the given timeout span.
    def initialize(
      @symbols : Array(String),
      stream : String,
      handler_class,
      @timeout : Time::Span = 0.seconds
    )
      @stream_names = build_stream_names(stream)
      @channel = Channel(ChannelMessage | ChannelClose | ChannelError).new
      @handlers = {} of String => Binance::Handler
      @symbols.each do |symbol|
        @handlers[symbol.upcase] = handler_class.new(symbol)
      end

      @websocket = open_connection
    end

    def initialize(
      symbol : String,
      stream : String,
      handler_class,
      @timeout : Time::Span = 0.seconds
    )
      @symbols = [symbol]
      @stream_names = build_stream_names(stream)
      @channel = Channel(ChannelMessage | ChannelClose | ChannelError).new
      @handlers = {} of String => Binance::Handler
      @symbols.each do |symbol|
        @handlers[symbol.upcase] = handler_class.new(symbol)
      end

      @websocket = open_connection
    end

    def open_connection
      host = "stream.binance.com"
      path = "/stream?streams=#{stream_names}"
      port = 9443
      puts "opening #{symbols_param}"
      HTTP::WebSocket.new(host, path, port, tls: true).tap{ |ws| attach_events(ws) }
    end

    def attach_events(ws)
      ws.on_message do |message|
        @last_seen = Time.utc
        @messages += 1
        @channel.send ChannelMessage.new(message)
      end

      ws.on_close do |code, message|
        @last_seen = Time.utc
        @stopped = true
        puts "Closed: #{message}"
        @channel.send ChannelClose.new(message)
      end

      ws.on_ping do |message|
        @last_seen = Time.utc
        puts "#{stream_names} #{Time.utc.to_s}: Processed #{@messages.to_s} messages"
        ws.pong
      end
      return ws
    end

    def build_stream_names(stream_name : String)
      @symbols.map{|s| "#{s.downcase}@#{stream_name}"}.join("/")
    end

    def build_stream_names(stream_names : Array(String))
      stream_names.map do |stream_name|
        @symbols.map{|s| "#{s.downcase}@#{stream_name}"}.join("/")
      end.join("/")
    end

    def symbols_param
      @symbols.join(",").downcase
    end

    def listen
      puts "opening ws connection"
      spawn do
        begin
          start_watcher
          websocket.run
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
      listen

      while message = @channel.receive?
        case message

        when ChannelMessage
          stream = message_stream(message)
          handler = @handlers[SENTINEL]? || @handlers[stream.symbol]
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