module Binance::Responses
  class FilterException < Exception
  end

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
    # TRUE if API endpoint successfully processed, FALSE otherwise
    property success : Bool = true

    @[JSON::Field(ignore: true)]
    # The error code returned by the API endpoint (if any).
    property error_code : Int32?

    @[JSON::Field(ignore: true)]
    # The error message from either the API endpoint or Exception captured (if any).
    property error_message : String?

    @[JSON::Field(ignore: true)]
    # The full HTTP Response object captured (if any).
    property response : HTTP::Client::Response?

    @[JSON::Field(ignore: true)]
    # The exception captured (if any).
    property exception : Exception?

    # :nodoc:
    def initialize
      @response = nil
      @error_code = nil
      @error_message = nil
      @exception = nil
    end

    # The unparsed body of the HTTP response
    def body
      @response.nil? ? "" : @response.as(HTTP::Client::Response).body
    end

    def used_weight
      return 0 if @response.nil?
      value = @response.as(HTTP::Client::Response).headers["X-MBX-USED-WEIGHT"]?
      value.nil? ? 0 : value.to_i
    end

    # :nodoc:
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

    # :nodoc:
    def self.from_failure(response)
      self.new.tap do |r|
        r.success = false
        r.error_message = response.body
        r.response = response
      end
    end

    # :nodoc:
    def self.from_exception(exception)
      self.new.tap do |r|
        r.success = false
        r.error_message = exception.message
        r.exception = exception
      end
    end
  end
end
