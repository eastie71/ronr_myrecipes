class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end
  
  def show
    @recipe = Recipe.find(params[:id])
  end
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    # Hard-code chef for time-being - will be logged in later
    @recipe.chef = Chef.first
    if @recipe.save
      flash[:success] = "Recipe successfully created!"
      # Go the recipe SHOW page
      redirect_to recipe_path(@recipe)
    else
      render 'new'
    end
  end
  
  private
    # white list the recipe parameters passed through to create action
    def recipe_params
      params.require(:recipe).permit(:name,:description)
    end
end