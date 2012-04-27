module UserSession
  def current_user
    @current_user ||= login_from_session
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def login?
    !!current_user
  end

  def login_required
    unless login?
      store_location
      redirect '/signin'
    end
  end

  def login_from_session
    if session[:user].present?
      User.find(session[:user])
    end
  end

  def logout_user
    session.delete(:user)
    @current_user = nil
  end

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to] = nil
      redirect return_to
    else
      redirect '/'
    end
  end
end
