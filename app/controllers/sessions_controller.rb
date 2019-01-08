class SessionsController < ApplicationController
  def new
  end
  
  def create
    chef = Chef.find_by(email: params[:session][:email].downcase)
    if chef && chef.authenticate(params[:session][:password])
      session[:chef_id] = chef.id
      flash[:success] = "You are now logged in"
      # This is short for chef_path(chef)
      redirect_to chef
    else
      # the ".now" is for just the CURRENT page (new) cycle message ONLY
      flash.now[:danger] = "Email or Password is invalid"
      render 'new'
    end
  end
  
  def destroy
    session[:chef_id] = nil
    flash[:success] = "You have logged out"
    redirect_to root_path
  end
end