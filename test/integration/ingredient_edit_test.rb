require 'test_helper'

class IngredientEditTest < ActionDispatch::IntegrationTest
  def setup
    @admin = Chef.create!(chefname: "Craig", email: "cde@mail.com.au",
                            password: "password", password_confirmation: "password", admin: true)
    @nonAdmin = Chef.create!(chefname: "Betty", email: "betty@mail.com.au",
                            password: "password", password_confirmation: "password", admin: false)
    @aIngredient = Ingredient.create!(name: "Apples")
  end
  
  test "accept valid ingredient edit" do
    sign_in_as(@admin, @admin.password)
    get edit_ingredient_path(@aIngredient)
    assert_template 'ingredients/edit'
    updated_name = "Oranges"
    # Update the edit
    patch ingredient_path(@aIngredient), params: {ingredient: {name: updated_name}}
    # alternative to using follow_redirect! - use assert_redirected_to
    assert_redirected_to @aIngredient
    # Check that the success flash message is not empty
    assert_not flash.empty?
    @aIngredient.reload
    assert_match updated_name, @aIngredient.name
  end
  
  test "reject invalid ingredient edit" do
    sign_in_as(@admin, @admin.password)
    get edit_ingredient_path(@aIngredient)
    assert_template 'ingredients/edit'
    updated_name = "1"
    # Update the edit
    patch ingredient_path(@aIngredient), params: {ingredient: {name: updated_name}}
    assert_template 'ingredients/edit'
    @aIngredient.reload
    assert_no_match updated_name, @aIngredient.name
  end
  
  test "reject non-admin user ingredient edit" do
    sign_in_as(@nonAdmin, @nonAdmin.password)
    get edit_ingredient_path(@aIngredient)
    updated_name = "Oranges"
    # Try Update the edit
    patch ingredient_path(@aIngredient), params: {ingredient: {name: updated_name}}
    @aIngredient.reload
    assert_no_match updated_name, @aIngredient.name
  end
end
