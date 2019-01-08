class RecipesController < ApplicationController
  before_action :set_current_recipe, only: [:show,:edit,:update,:destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user_or_admin, only: [:edit, :update, :destroy]
  
  def index
    # Using the will_paginate gem for page pagination
    @recipes = Recipe.paginate(:page => params[:page], :per_page => 5)
  end
  
  def show
  end
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    # Use the logged in chef
    @recipe.chef = current_chef
    if @recipe.save
      flash[:success] = "Recipe successfully created."
      # Go the recipe SHOW page
      redirect_to recipe_path(@recipe)
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @recipe.update(recipe_params)
      flash[:success] = "Updated Recipe OK."
      # Go the recipe SHOW page
      redirect_to recipe_path(@recipe)
    else
      render 'edit'
    end
  end
  
  def destroy
    # Not sure if destroy can fail - not sure what to do?
    @recipe.destroy
    flash[:danger] = "Recipe: \"" + @recipe.name + "\" deleted"
    # Return to Index page
    redirect_to recipes_path
  end
  
  private
    def set_current_recipe
      @recipe = Recipe.find(params[:id])
    end
  
    # white list the recipe parameters passed through to create action
    def recipe_params
      params.require(:recipe).permit(:name,:description)
    end
    
    def require_same_user_or_admin
      if current_chef != @recipe.chef && !current_chef.admin?
        flash[:danger] = "You can only edit or delete your own recipes!"
        redirect_to recipes_path
      end
    end
end