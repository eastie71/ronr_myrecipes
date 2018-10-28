require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  
  def setup
    @recipe = Recipe.new(name: "beef curry", description: "Spicy and tasty Beef Curry.")
  end
  
  test "recipe should be valid" do
    assert @recipe.valid?
  end
  
  test "name cannot be blank" do
    @recipe.name = ""
    assert_not @recipe.valid?
  end
  
  test "description cannot be blank" do
    @recipe.description = ""
    assert_not @recipe.valid?
  end
  
  test "description less than max length" do
    @recipe.description = "A" * 501
    assert_not @recipe.valid?;
  end
  
  test "description greater than min length" do
    @recipe.description = "A" * 3
    assert_not @recipe.valid?;
  end
  
end