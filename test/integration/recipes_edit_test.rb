require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  def setup
    @aChef = Chef.create!(chefname: "Craig", email: "cde@mail.com.au",
                            password: "password", password_confirmation: "password")
    @aRecipe = Recipe.create!(name: "Best bbq bangers", description: "awesome bbq sausages.", chef: @aChef)
  end
  
  test "accept valid recipe edit" do
    sign_in_as(@aChef, @aChef.password)
    get edit_recipe_path(@aRecipe)
    assert_template 'recipes/edit'
    updated_recipe_name = "UPDATED chocolate cake"
    updated_recipe_description = "UPDATED Melt dark chocalate, add sugar, eggs, flour, bake for 45 mins and 180 c"
     # Update the edit
    patch recipe_path(@aRecipe), params: {recipe: {name: updated_recipe_name, description: updated_recipe_description}}
    # alternative to using follow_redirect! - use assert_redirected_to
    assert_redirected_to @aRecipe
    # Check that the success flash message is not empty
    assert_not flash.empty?
    @aRecipe.reload
    assert_match updated_recipe_name, @aRecipe.name
    assert_match updated_recipe_description, @aRecipe.description
  end

  test "reject invalid recipe edit" do 
    sign_in_as(@aChef, @aChef.password)
    get edit_recipe_path(@aRecipe)
    assert_template 'recipes/edit'
    # Reject the edit as the name is changed to BLANK
    patch recipe_path(@aRecipe), params: {recipe: {name: " ", description: "some description"}}
    assert_template 'recipes/edit'
    # Check for panel-title and panel-body in the HTML - this will appear of any errors occur
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end

end
