require "./lib/user_session"

class App
  helpers do
    include Rack::Utils
    include UserSession
    alias_method :h, :escape_html
  end
end