config[:progress] = {}
environment :production do
end

environment :development do
  config[:server_url] = "http://localhost:9000"
end

environment :test do
  config[:server_url] = "http://localhost:9900"
end

