module Binance::Responses
  class ServerResponse
    include JSON::Serializable

    @[JSON::Field(ignore: true)]
    property success : Bool = true

    @[JSON::Field(ignore: true)]
    property error : String?

    @[JSON::Field(ignore: true)]
    property response : Cossack::Response?

    def initialize
      @response = nil
      @error = nil
    end

    def body
      @response.nil? ? "" : @response.as(Cossack::Response).body
    end

    def after_serialization
      # NOP
    end

    def self.from_error(response)
      self.new.tap do |r|
        r.success = false
        r.error = response.body
        r.response = response
      end
    end

    def self.from_failure(response)
      self.new.tap do |r|
        r.success = false
        r.error = response.body
        r.response = response
      end
    end

    def self.from_exception(exception)
      self.new.tap do |r|
        r.error = exception.message
      end
    end
  end
end