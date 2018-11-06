require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  def setup
    @aChef = Chef.create!(chefname: "Craig", email: "cde@mail.com.au")
    @aRecipe = Recipe.create!(name: "best bbq bangers", description: "awesome bbq sausages.", chef: @aChef)
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
    assert_match @aRecipe.name, response.body
    assert_match @aRecipe2.name, response.body
  end
end
