class LikesController < ApplicationController
  before_action :require_user
  
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @like = @recipe.likes.build(chef: current_chef)
    if @recipe.chef == current_chef
      flash[:danger] = "You cannot like your own recipe!"
    elsif !@like.save
      flash[:danger] = "Like failed!"
    end
    redirect_back(fallback_location: root_path)
  end
  
  def destroy
    @like = Like.find(params[:id])
    
    if @like.chef == current_chef
      @like.destroy
      #flash[:danger] = "Comment has been deleted!"
      # redirect_to recipe_path(@like.recipe)
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "You are not authorised to remove this like!"
      redirect_to root_path
    end
  end
    
end