class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :admin_user

  def current_user
    session[:user_id].nil? ? nil : User.find(session[:user_id])
  end

  def admin_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id]).admin?
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'You need to sign in first' unless current_user
  end

  def ensure_that_admin_user
    redirect_to signin_path, notice: 'This action requires administrator privileges' unless admin_user
  end
end
