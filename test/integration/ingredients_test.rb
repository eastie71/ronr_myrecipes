require 'test_helper'

class IngredientsTest < ActionDispatch::IntegrationTest
  def setup
    @aIngredient = Ingredient.create(name: "Onion")
    @aIngredient2 = Ingredient.create(name: "Sweet Paprika")
    @admin = Chef.create!(chefname: "Craig", email: "cde@mail.com.au",
                    password: "password", password_confirmation: "password", admin: true)
    @nonAdmin = Chef.create!(chefname: "Barry", email: "bazza@mail.com.au",
                    password: "password", password_confirmation: "password", admin: false)
  end
  
  test "should get ingredients index" do
    get ingredients_path
    assert_response :success
  end
  
  test "should get the ingredients list" do
    get ingredients_path
    assert_template 'ingredients/index'
    # search for links to the specific ingredients pages (a tags) - which are on the Ingredient names
    assert_select "a[href=?]", ingredient_path(@aIngredient), text: @aIngredient.name
    assert_select "a[href=?]", ingredient_path(@aIngredient2), text: @aIngredient2.name
  end
  
  test "admin chef should have edit ingredient option" do
    sign_in_as(@admin, @admin.password)
    get ingredients_path
    assert_template 'ingredients/index'
    # search for links to the edit
    assert_select "a[href=?]", edit_ingredient_path(@aIngredient), text: "Edit"
  end
  
  test "non admin chef should not have edit ingredient option" do
    sign_in_as(@nonAdmin, @nonAdmin.password)
    get ingredients_path
    assert_template 'ingredients/index'
    # no links to the edit should exist
    assert_select "a[href=?]", edit_ingredient_path(@aIngredient), { count: 0, text: "Edit" } 
  end
end
