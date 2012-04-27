class App
  # use Rack::Auth::Basic, "Protected Area" do |username, password|
  #   username == 'foo' && password == 'bar'
  # end

  configure :development do |config|
    require "sinatra/reloader"
    register Sinatra::Reloader
    config.also_reload "models/*.rb"
  end

  enable  :sessions, :logging
  disable :run, :reload

  set :root, File.dirname(__FILE__)
  set :views, File.join(root, "views")
  set :haml, {:format => :html5}
  set :public_folder, File.join(root, "public")
  set :environment, :production if RUBY_PLATFORM =~ /linux/i

  file = File.expand_path("./../config/mongoid.yml", __FILE__)
  Mongoid.from_hash YAML.load_file(file)[settings.environment.to_s]
end
