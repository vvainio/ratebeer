class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back, #{user.username}!"
    else
      redirect_to :back, notice: 'Username and/or password mismatch!'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
