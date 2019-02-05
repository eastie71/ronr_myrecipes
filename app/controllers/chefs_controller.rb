class ChefsController < ApplicationController
  before_action :set_chef, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user_or_admin, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]
  
  def new
    @chef = Chef.new
  end
  
  def index
    @chefs = Chef.paginate(:page => params[:page], :per_page => 5)
  end
  
  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      # Set the NEW chef as the current logged in chef
      session[:chef_id] = @chef.id
      cookies.signed[:chef_id] = @chef.id
      flash[:success] = "Welcome #{@chef.chefname} to the MyRecipes App!"
      redirect_to chef_path(@chef)
    else
      render 'new'
    end
  end
  
  def show
    @chef_recipes = @chef.recipes.paginate(:page => params[:page], :per_page => 5)
  end
  
  def edit
  end
  
  def update
    if @chef.update(chef_params)
      flash[:success] = "Your account was updated successfully."
      # Go the chef SHOW page
      redirect_to @chef
    else
      render 'edit'
    end
  end
  
  def destroy
    # Do not allow deletion of admin chefs
    if !@chef.admin? 
      @chef.destroy
      flash[:danger] = "Chef: \"" + @chef.chefname + "\" and all associated Recipes and Comments have been deleted!"
      # Return to Index page
      redirect_to chefs_path
    end
  end
  
  private
  
  def chef_params
    params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
  end

  def set_chef
    @chef = Chef.find(params[:id])
  end
  
  def require_same_user_or_admin
    if current_chef != @chef && !current_chef.admin?
      flash[:danger] = "You can only edit or delete your own account!"
      redirect_to chef_path(current_chef)
    end
  end
  
  def require_admin
    if !current_chef.admin?
      flash[:danger] = "Only admin users can perform this action"
      redirect_to root_path
    end
  end
end