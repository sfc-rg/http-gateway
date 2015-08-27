class ApplicationController < ActionController::Base
  def domain
    @domain ||= Domain.new(request)
  end
  helper_method :domain

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
