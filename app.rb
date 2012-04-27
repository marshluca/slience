require "rubygems"
require "sinatra"
require "sinatra/base"
require "mongoid"
require "logger"

class App < Sinatra::Base
  require './init'
  require './models'
  require './helpers'

  error do
    e = request.env['sinatra.error']
    Kernel.puts e.backtrace.join("\n")
    'Application error ... '
  end

  before do
    p '-' * 100
    p request.params.inspect
    
    unless request.path =~ /sign/i
      login_required
    end
  end

  get '/' do    
    redirect '/feeds'
  end

  get '/signin' do
    haml :signin
  end

  post '/signin' do
    if @user = User.auth_emrms(params[:email], params[:password])
      session[:user] = @user.id.to_s
      redirect_to_stored
    else
      redirect '/signin'
    end
  end

  get '/signup' do
    haml :signup
  end

  post '/signup' do
    @user = User.build_emrms(params[:user])
    if @user && @user.valid?
      session[:user] = @user.id.to_s
      redirect '/'
    else
      redirect '/signup'
    end
  end

  get '/signout' do
    logout_user
    redirect '/signin'
  end

  get '/feeds' do
    @feeds = Feed.page(params[:page])
    @title = 'All Syncronize List'
    haml :feeds
  end

  get '/feeds/:kind' do
    @feeds = Feed.kind(params[:kind]).page(params[:page])
    @title = "Syncronize List on #{params[:kind]}"
    haml :feeds
  end

  get '/:user/feeds' do
    @feeds = Feed.from_user(params[:user]).page(params[:page])
    @title = "Syncronize List from #{params[:user]}"
    haml :feeds
  end
end