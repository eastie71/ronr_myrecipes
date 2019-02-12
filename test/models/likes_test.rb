require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.create!(chefname: "Craig Eastwood", email: "craig@test.com",
                      password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "Georgia Eastwood", email: "georgia@test.com",
                      password: "password", password_confirmation: "password")
    @recipe = @chef.recipes.build(name: "beef curry", description: "Spicy and tasty Beef Curry.")
    @recipe.save
    @recipe2 = @chef2.recipes.build(name: "chicken curry", description: "Spicy and tasty Chicken Curry.")
    @recipe2.save
    @like = @recipe.likes.build(chef: @chef2)
  end
  
  test "like should be valid" do
    assert @like.valid?
  end
  
  test "like cannot be empty" do
    @like.chef = nil
    assert_not @like.valid?
  end
  
  test "like cannot be duplicated" do
    @like.save
    @like2 = @recipe.likes.build(chef: @chef2)
    assert_not @like2.valid?
  end
  
  test "new unique like valid" do
    @like.save
    @like2 = @recipe2.likes.build(chef: @chef)
    assert @like2.valid?
  end
end