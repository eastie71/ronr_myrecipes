class RecipesController < ApplicationController
  before_action :set_current_recipe, only: [:show,:edit,:update,:destroy]
  
  def index
    @recipes = Recipe.all
  end
  
  def show
  end
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    # Hard-code chef for time-being - will be logged in later
    @recipe.chef = Chef.first
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
    flash[:success] = "Recipe: \"" + @recipe.name + "\" deleted"
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
end