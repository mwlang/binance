module Binance::Responses
  # The ServerResponse class is the base class returned for all endpoint calls
  #  * If the endpoint call was successfully executed and parsed, then
  # the success property will be true.  Otherwise it will be false and
  # error property will contain the error message.
  #  * If the endpoint itself is returning an error, the error_code will
  # also be populated.  
  # * If an exception occurred (for example timeout error), then it's 
  # message is captured to the error property and the exception itself
  # is captured to the exception property.
  # In all cases, the raw response from the endpoint is captured to
  # the response property.
  #
  class ServerResponse
    include JSON::Serializable

    @[JSON::Field(ignore: true)]
    property success : Bool = true

    @[JSON::Field(ignore: true)]
    property error_code : Int32?

    @[JSON::Field(ignore: true)]
    property error_message : String?

    @[JSON::Field(ignore: true)]
    property response : Cossack::Response?

    @[JSON::Field(ignore: true)]
    property exception : Exception?

    def initialize
      @response = nil
      @error_code = nil
      @error_message = nil
      @exception = nil
    end

    def body
      @response.nil? ? "" : @response.as(Cossack::Response).body
    end

    def after_serialization
      # @success = @error_message.nil? && @error_code.nil?
    end

    def self.from_error(response)
      self.new.tap do |r|
        r.success = false
        r.response = response
        begin
          json = JSON.parse response.body
          r.error_message = json["msg"].to_s
          r.error_code = json["code"].as_i
        rescue
          r.error_code = -1
          r.error_message = response.body
          r.response = response
        end
      end
    end

    def self.from_failure(response)
      self.new.tap do |r|
        r.success = false
        r.error_message = response.body
        r.response = response
      end
    end

    def self.from_exception(exception)
      self.new.tap do |r|
        r.success = false
        r.error_message = exception.message
        r.exception = exception
      end
    end
  end
end