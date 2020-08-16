require "../src/binance"

client = Binance::REST.new

puts client.ping.pong.inspect

# # <Binance::Responses::PingResponse:0x10d40c280
#   @success=true,
#   @error_code=nil,
#   @error_message=nil,
#   @response=#<Cossack::Response:0x10d3fe5a0 @status=200,
#     @headers=HTTP::Headers{
#       "Content-Type" => "application/json;charset=utf-8",
#       "Transfer-Encoding" => "chunked",
#       "Connection" => "keep-alive",
#       "Date" => "Tue, 02 Jul 2019 15:26:47 GMT",
#       "Server" => "nginx",
#       "Vary" => "Accept-Encoding",
#       "X-MBX-USED-WEIGHT" => "3",
#       "Strict-Transport-Security" =>
#       "max-age=31536000; includeSubdomains",
#       "X-Frame-Options" => "SAMEORIGIN",
#       "X-Xss-Protection" => "1; mode=block",
#       "X-Content-Type-Options" => "nosniff",
#       "Content-Security-Policy" => "default-src 'self'",
#       "X-Content-Security-Policy" => "default-src 'self'",
#       "X-WebKit-CSP" => "default-src 'self'",
#       "Cache-Control" => "no-cache, no-store, must-revalidate",
#       "Pragma" => "no-cache",
#       "Expires" => "0",
#       "Content-Encoding" => "gzip",
#       "X-Cache" => "Miss from cloudfront",
#       "Via" => "1.1 f5d17f65245ed818b0a01bb46646051c.cloudfront.net (CloudFront)",
#       "X-Amz-Cf-Pop" => "ATL50-C1",
#       "X-Amz-Cf-Id" => "-lcrDlHfRIAYp7ULZLmEqNzDMCU8U4q5LnS60csCxtYe-SRY3qqqTQ=="
#       },
#     @body="{}">,
#   @exception=nil>
