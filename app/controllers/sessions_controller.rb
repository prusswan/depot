class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
  end

  def create
    if User.count.zero?
      user = User.create(name: params[:name],
                         password: params[:password],
                         password_confirmation: params[:password])
    else
      user = User.find_by_name(params[:name])
      if !user or !user.authenticate(params[:password])
        redirect_to login_url, alert: "Invalid user/password combination"
        return
      end
    end

    session[:user_id] = user.id
    redirect_to admin_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_url, notice: "Logged out"
  end
end
