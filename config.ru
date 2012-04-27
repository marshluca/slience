require 'rubygems'
require './app'
require './service'

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a+")
$stdout.reopen(log)
$stderr.reopen(log)

# run Sinatra::Application

# use Rack::Config do |env|
#   env['api.tilt.root'] = File.expand_path(File.dirname(__FILE__) + '/views/rabl')
# end

puts "Booting the application in #{ENV['RACK_ENV'] || 'development'}"

map "/" do
  use Rack::Static, :urls => ["/stylesheets", "/images", "/javascripts"], :root => "public"  
  use Rack::Session::Cookie, :key => 'ardency_api_key', :path => '/', :expire_after => 14400, :secret => 'ardency_api_secret'
  use Rack::Mongoid::Middleware::IdentityMap
  run Rack::Cascade.new([App, Service])
end
