require 'test_helper'

class IngredientShowTest < ActionDispatch::IntegrationTest
  def setup
    @aIngredient = Ingredient.create(name: "Onion")
    #@aIngredient2 = Ingredient.create(name: "Sweet Paprika")
    @aChef = Chef.create!(chefname: "Craig", email: "cde@mail.com.au",
                    password: "password", password_confirmation: "password")
    @aRecipe = Recipe.create!(name: "Best bbq bangers", description: "awesome bbq sausages.", chef: @aChef)
    @aRecipe2 = @aChef.recipes.build(name: "chocalate cake", description: "fast and easy chocalate cake")
    @aRecipe2.save
    RecipeIngredient.create!(ingredient: @aIngredient, recipe: @aRecipe)
    RecipeIngredient.create!(ingredient: @aIngredient, recipe: @aRecipe2)
  end
  
  test "should get ingredients show page for associated recipes" do
    get ingredient_path(@aIngredient)
    assert_template 'ingredients/show'
    # search for links to the specific recipe pages (a tags) - which are on the Recipe names
    assert_select "a[href=?]", recipe_path(@aRecipe), text: @aRecipe.name
    assert_select "a[href=?]", recipe_path(@aRecipe2), text: @aRecipe2.name
    
    # check for recipe descriptions and ingredient name showing up
    assert_match @aRecipe.description, response.body
    assert_match @aRecipe2.description, response.body
    assert_match @aIngredient.name, response.body
  end
end
