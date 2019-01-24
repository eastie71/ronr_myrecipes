require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.create!(chefname: "Craig Eastwood", email: "craig@test.com",
                      password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "Georgia Eastwood", email: "georgia@test.com",
                      password: "password", password_confirmation: "password")
    @recipe = @chef.recipes.build(name: "beef curry", description: "Spicy and tasty Beef Curry.")
    @recipe.save
    @comment = @recipe.comments.build(description: "Sooooo tasty", chef: @chef)
  end
  
  test "comment should be valid" do
    assert @comment.valid?
  end
  
  test "comment cannot be too small" do
    @comment.description = "12"
    assert_not @comment.valid?
  end
  
  test "comment cannot be too large" do
    @comment.description = "A" * 200
    assert_not @comment.valid?
  end
  
  test "comment cannot be blank" do
    @comment.description = ""
    assert_not @comment.valid?
  end
  
  test "comment should be valid with different chef from recipe" do
    @comment.chef = @chef2
    assert @comment.valid?
  end
end