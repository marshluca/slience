require "rubygems"
require "yajl"
require "grape"

class Service < Grape::API
  prefix "api"
  version "v1"

  helpers do
    def authenticate!
      error!('401 Unauthorized', 401) unless params[:appkey]
    end

    def params_exist_blank?(*params)
      params.detect { |param| return true if param.blank? }
    end

    def find_user_and_device_and_timestamp
      @user = User.find(params[:uid])
      @device = Device.find_or_build_by(params[:device])
      @timestamp = Time.parse(params[:timestamp])
      [@user, @device, @timestamp]
    end

    def response_code(status, message)
      {:status => status, :message => message}
    end
  end

  get '/test' do
    {:messsage => 'Hello World !', :version => version}
  end

  post '/signin' do
    @user =  User.authenticate(params[:email], params[:password])
    @user ? @user.profile : response_code(false, 'Sign in failured.')
  end

  post '/signup' do
    if params_exist_blank? params[:user]
      response_code(false, 'Missing parameters.')
    else
      @user = User.build_emrms(params[:user])
      @user && @user.valid? ? @user.profile : response_code(false, @user.full_errors)
    end
  end
  
  post '/:user/update' do
    @user = User.where(:_id=>params[:user][:name]).first
    if @user and @user.update_attributes(params[:user])
      @user.profile
    else
      response_code(false, "update failured.")
    end
  end

  namespace :sync do
    Record::UNITS.keys.each do |act|
      post "/#{act}" do
        puts params.inspect
        if params_exist_blank? params[:uid], params[:device]
          response_code(false, 'Missing parameters.')
        else
          @user, @device, @timestamp = find_user_and_device_and_timestamp
          record = {:key => act, :value => params[:record], :created_at => @timestamp}
          feed = Feed.build(@user, @device, record, params[:network])
          if feed && feed.valid?
            response_code(true, "#{act} syncronized successfully.")
          else
            response_code(false, "#{act} syncronized failured.")
          end
        end
      end
    end
  end
end
