class TimestampRequestMiddleware < Cossack::Middleware
  def call(request)
    puts "#{request.method} #{request.uri}"
    app.call(request).tap do |response|
      puts "Response: #{response.status} #{response.body}"
    end
  end
end