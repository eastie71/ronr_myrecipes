require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  def setup
    @aChef = Chef.create!(chefname: "Craig", email: "cde@mail.com.au")
    @aRecipe = Recipe.create!(name: "Best bbq bangers", description: "awesome bbq sausages.", chef: @aChef)
    @aRecipe2 = @aChef.recipes.build(name: "chocalate cake", description: "fast and easy chocalate cake")
    @aRecipe2.save
  end
  
  test "should get recipes index" do
    get recipes_path
    assert_response :success
  end
  
  test "should get the recipes list" do
    get recipes_path
    assert_template 'recipes/index'
    # search for links to the specific recipe pages (a tags) - which are on the Recipe names
    assert_select "a[href=?]", recipe_path(@aRecipe), text: @aRecipe.name
    assert_select "a[href=?]", recipe_path(@aRecipe2), text: @aRecipe2.name
  end
  
  test "should get the recipes show" do
    get recipe_path(@aRecipe)
    assert_template 'recipes/show'
    # search for the recipe name, description and chef name in the body of the page
    assert_match @aRecipe.name, response.body
    assert_match @aRecipe.description, response.body
    assert_match @aChef.chefname, response.body
  end
end
