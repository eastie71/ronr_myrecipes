require 'test_helper'

class RecipeCommentTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Craig Eastwood", email: "craig@test.com",
                      password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "Georgia Eastwood", email: "georgia@test.com",
                      password: "password", password_confirmation: "password")
    @admin_chef = Chef.create!(chefname: "ADMIN", email: "admin@test.com",
                      password: "password", password_confirmation: "password", admin: true)
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
  
  test "chef should have ability to delete their own comment" do
    sign_in_as(@chef2, @chef2.password)
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    # Check there is a Delete Comment button link
    assert_select 'a[href=?]', recipe_comment_path(@recipe, @comment), text: "Delete Comment"
    # Check that count decreases by 1 on delete
    assert_difference 'Comment.count', -1 do
      delete recipe_comment_path(@recipe, @comment)
    end
    assert_not flash.empty?
  end
  
  test "chef should not have ability to delete other chef comments" do
    sign_in_as(@chef, @chef.password)
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    # Check there is a Delete Comment button link
    assert_select 'a[href=?]', recipe_comment_path(@recipe, @comment), { count: 0, text: "Delete Comment" }
    # Check that count DOES NOT decrease by 1 on attempted delete
    assert_no_difference 'Comment.count' do
      delete recipe_comment_path(@recipe, @comment)
    end
    assert_not flash.empty?
  end

  test "admin chef can delete any comments" do
    sign_in_as(@admin_chef, @admin_chef.password)
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    # Check there is a Delete Comment button link
    assert_select 'a[href=?]', recipe_comment_path(@recipe, @comment), text: "Delete Comment"
    # Check that count decreases by 1 on delete
    assert_difference 'Comment.count', -1 do
      delete recipe_comment_path(@recipe, @comment)
    end
    assert_not flash.empty?
  end
end
