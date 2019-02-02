require 'test_helper'

class RecipeCommentTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Craig Eastwood", email: "craig@test.com",
                      password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "Georgia Eastwood", email: "georgia@test.com",
                      password: "password", password_confirmation: "password")
    @recipe = @chef.recipes.build(name: "beef curry", description: "Spicy and tasty Beef Curry.")
    @recipe.save
    @comment = @recipe.comments.build(description: "Sooooo tasty", chef: @chef2)
    @comment.save
  end
  
  test "should show the recipe comment" do
    sign_in_as(@chef, @chef.password)
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    # Search for the comment description and chef name in the body of the page
    assert_match @comment.description, response.body
    assert_match @chef2.chefname, response.body
  end
  
  test "chef should have ability to add valid comment on recipe show page" do
    sign_in_as(@chef, @chef.password)
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    new_comment = "Thanks Georgia!"
    # Check to see if the count of the number of comments increases if valid comment is entered
    assert_difference 'Comment.count' do
      post recipe_comments_path(@recipe), params: { comment: {description: new_comment}  }
    end
    # Follow the redirect to the SHOW page
    follow_redirect!
    assert_template 'recipes/show'
    # Check for flash message of successful create
    assert_not flash.empty?
    # Search for the new comment description and chef name in the body of the page
    assert_match new_comment, response.body
    assert_match @chef.chefname, response.body
  end
  
  test "should reject adding an empty comment" do
    sign_in_as(@chef, @chef.password)
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    empty_comment = " "
    # Check to see if the count of the number of comments increases if empty comment is entered
    assert_no_difference 'Comment.count' do
      post recipe_comments_path(@recipe), params: { comment: {description: empty_comment}  }
    end
    # Check for flash message of error on create
    assert_not flash.empty?
  end
  
  test "not logged in should not be able to add comment" do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    new_comment = "Comment should fail as not logged in!"
    # Check to see if the count of the number of comments increases if valid comment is entered
    assert_no_difference 'Comment.count' do
      post recipe_comments_path(@recipe), params: { comment: {description: new_comment}  }
    end
    # Follow the redirect to the HOME page
    follow_redirect!
    assert_template 'pages/home'
  end
end
