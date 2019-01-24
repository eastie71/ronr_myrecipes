class IngredientsController < ApplicationController
  before_action :setup_ingredient, only: [:show, :edit, :update]
  before_action :require_admin, except: [:index, :show]
  
  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      flash[:success] = "Ingredient created successfully"
      redirect_to ingredient_path(@ingredient)
    else
      render 'new'
    end
  end

  def show
    @ingredient_recipes = @ingredient.recipes.paginate(page: params[:page], per_page: 5)
  end

  def edit
  end

  def update
    if @ingredient.update(ingredient_params)
      flash[:success] = "Ingredient updated successfully"
      redirect_to @ingredient
    else
      render 'edit'
    end
  end

  def index
    @ingredients = Ingredient.paginate(page: params[:page], per_page: 5)
  end
  
  private
  
    def setup_ingredient
      @ingredient = Ingredient.find(params[:id])
    end
    
    def ingredient_params
      params.require(:ingredient).permit(:name)
    end
    
    def require_admin
      if !logged_in? || !current_chef.admin?
        flash[:danger] = "Only admin users can perform this action"
        redirect_to ingredients_path
      end
    end
end