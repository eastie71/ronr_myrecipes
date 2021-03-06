require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  def setup
    @aChef = Chef.create!(chefname: "Craig", email: "cde@mail.com.au",
                    password: "password", password_confirmation: "password")
    @aRecipe = Recipe.create!(name: "Best Bbq Bangers", description: "awesome bbq sausages.", chef: @aChef)
    @aRecipe2 = @aChef.recipes.build(name: "Chocalate Cake", description: "fast and easy chocalate cake")
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
    sign_in_as(@aChef, @aChef.password)
    get recipe_path(@aRecipe)
    assert_template 'recipes/show'
    # search for the recipe name, description and chef name in the body of the page
    assert_match @aRecipe.name, response.body
    assert_match @aRecipe.description, response.body
    assert_match @aChef.chefname, response.body
    # There should be EDIT and DELETE actions as button links
    assert_select 'a[href=?]', edit_recipe_path(@aRecipe), text: "Edit Recipe"
    assert_select 'a[href=?]', recipe_path(@aRecipe), text: "Delete Recipe"
    assert_select 'a[href=?]', recipes_path, text: "Return to Recipes List"
  end
  
  test "create new valid recipe" do
    sign_in_as(@aChef, @aChef.password)
    get new_recipe_path
    assert_template 'recipes/new'
    my_recipe_name = "Chocolate Cake"
    my_recipe_description = "Melt dark chocalate, add sugar, eggs, flour, bake for 45 mins and 180 c"
    # Check to see if the count of the number of recipes increases if valid recipe is entered
    assert_difference 'Recipe.count' do
      post recipes_path, params: { recipe: {name: my_recipe_name, description: my_recipe_description}}
    end
    # Follow the redirect to the SHOW page
    follow_redirect!
    assert_match my_recipe_name, response.body
    assert_match my_recipe_description, response.body
  end

  test "reject invalid new recipe" do
    sign_in_as(@aChef, @aChef.password)
    get new_recipe_path
    assert_template 'recipes/new'
    # Check to see if the count of the number of recipes increases, when trying to post an invalid recipe
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: { recipe: {name: " ", description: " "}}
    end
    assert_template 'recipes/new'
    # Check for panel-title and panel-body in the HTML - this will appear of any errors occur
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end
  
end
