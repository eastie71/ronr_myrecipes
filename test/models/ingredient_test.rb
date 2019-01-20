require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  def setup
    @ingredient = Ingredient.new(name: "Sweet Paprika")
  end
  
  test "ingredient should be valid" do
    assert @ingredient.valid?
  end
  
  test "ingredient cannot be too small" do
    @ingredient.name = "LB"
    assert_not @ingredient.valid?
  end
  
  test "ingredient cannot be too large" do
    @ingredient.name = "A" * 51
    assert_not @ingredient.valid?
  end
  
  test "ingredient cannot be blank" do
    @ingredient.name = ""
    assert_not @ingredient.valid?
  end
  
  test "ingredient must be unique" do
    @ingredient.save
    @same_ingredient = Ingredient.new(name: "Sweet Paprika")
    assert_not @same_ingredient.valid?
  end
end