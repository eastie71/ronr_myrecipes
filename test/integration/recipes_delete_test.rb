require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @aChef = Chef.create!(chefname: "Craig", email: "cde@mail.com.au")
    @aRecipe = Recipe.create!(name: "Best bbq bangers", description: "awesome bbq sausages.", chef: @aChef)
  end
  
  test "delete recipe is successful" do
    get recipe_path(@aRecipe)
    assert_template 'recipes/show'
    # Check there is a Delete Recipe button link
    assert_select 'a[href=?]', recipe_path(@aRecipe), text: "Delete Recipe"
    # Check that count decreases by 1 on delete
    assert_difference 'Recipe.count', -1 do
      delete recipe_path(@aRecipe)
    end
    # Should return to Index page and flash a success message
    assert_redirected_to recipes_path
    assert_not flash.empty?
  end
end
