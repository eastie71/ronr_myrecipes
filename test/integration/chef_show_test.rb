require 'test_helper'

class ChefShowTest < ActionDispatch::IntegrationTest
  def setup
    @aChef = Chef.create!(chefname: "Craig", email: "cde@mail.com.au",
                    password: "password", password_confirmation: "password")
    @aRecipe = Recipe.create!(name: "Best bbq bangers", description: "awesome bbq sausages.", chef: @aChef)
    @aRecipe2 = @aChef.recipes.build(name: "chocalate cake", description: "fast and easy chocalate cake")
    @aRecipe2.save
  end
  
  test "should get chefs show page" do
    get chef_path(@aChef)
    assert_template 'chefs/show'
    # search for links to the specific recipe pages (a tags) - which are on the Recipe names
    assert_select "a[href=?]", recipe_path(@aRecipe), text: @aRecipe.name
    assert_select "a[href=?]", recipe_path(@aRecipe2), text: @aRecipe2.name
    
    # check for recipe descriptions and chef name showing up
    assert_match @aRecipe.description, response.body
    assert_match @aRecipe2.description, response.body
    assert_match @aChef.chefname, response.body
  end
end
