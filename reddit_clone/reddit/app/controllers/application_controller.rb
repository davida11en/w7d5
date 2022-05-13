class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(session: session[:session_token])
  end

  def logged_in?
    !!curent_user
  end

  def login!(user)
    session[:session_token] = user.reset_session_token!
  end

  def logout!
    session[:session_token].reset_session_token! if logged_in?
  end


  def require_logged_in 
    
  end


end
