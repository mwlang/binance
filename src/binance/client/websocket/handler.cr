module Binance
  class Handler
    getter symbol : String
    property messages : Int32 = 0
    property stopped : Bool = false

    def initialize(@symbol : String)
    end

    def initialize
      @symbol = ""
    end

    def stopped?
      @stopped
    end

    def update(stream)
      puts "Nothing to do.  Override this method and do something useful"
    end
  end
end