class ApplicationController < ActionController::Base
  
  # by defining as helper methods they become available in the views (not just the controllers)
  helper_method :current_chef, :logged_in?
  
  def current_chef
    # ruby always returns the last line from a method
    # this means return the @current_chef if it exists, else go and find it if it doesn't
    @current_chef ||= Chef.find(session[:chef_id]) if session[:chef_id]
  end
  
  def logged_in?
    # by using the '!!' this will convert the return of any function to a true/false
    !!current_chef
  end
  
  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to root_path
    end
  end
end
