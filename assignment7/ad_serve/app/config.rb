configure do |app|
  Redis.current = Redis.new(:host => '127.0.0.1', :port => 6379)
  set :default_banner_url, 'http://google.com'
end

configure do |app|
  Redis.current = Redis.new(:host => '127.0.0.1', :port => 6379, :db => 1)
end
