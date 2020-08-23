module Binance
  class Handler
    getter symbol : String
    property messages : Int32 = 0

    def initialize(@symbol : String)
    end

    def update(stream)
      puts "Nothing to do.  Override this method and do something useful"
    end
  end
end