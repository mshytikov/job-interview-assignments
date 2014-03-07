config[:progress] = {}
config[:template] = {
  :views => File.expand_path('../app/views', File.dirname(__FILE__))
}

environment :production do
end

environment :development do
end

environment :test do
end

