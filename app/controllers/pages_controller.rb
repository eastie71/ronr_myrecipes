class PagesController < ApplicationController
  def home
    redirect_to current_chef if logged_in?
  end
end