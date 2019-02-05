class CommentsController < ApplicationController
  before_action :require_user
  
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.build(comment_params)
    @comment.chef = current_chef
    if @comment.save
      ActionCable.server.broadcast "comments", render(partial: 'comments/comment', object: @comment)
      # flash[:success] = "Comment submitted successfully"
      # redirect_to recipe_path(@recipe)
    else
      flash[:danger] = "Comment failed to submit! Please check you have entered a comment"
      redirect_back(fallback_location: root_path)
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    
    if @comment.chef == current_chef || current_chef.admin?
      @comment.destroy
      flash[:danger] = "Comment has been deleted!"
      redirect_to recipe_path(@comment.recipe)
    else
      flash[:danger] = "You are not authorised to delete this comment!"
      redirect_to root_path
    end
  end
  
  private
    def comment_params
      params.require(:comment).permit(:description)
    end
    
end