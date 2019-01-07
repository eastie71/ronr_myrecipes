require 'test_helper'

class ChefsListingTest < ActionDispatch::IntegrationTest
  def setup
    @aChef = Chef.create!(chefname: "Craig", email: "cde@mail.com.au",
                    password: "password", password_confirmation: "password")
    @aChef2 = Chef.create!(chefname: "John", email: "john@mail.com.au",
                    password: "password", password_confirmation: "password")
    @aRecipe = Recipe.create!(name: "Best Bbq Bangers", description: "awesome bbq sausages.", chef: @aChef)
  end
  
  test "should get the chefs list page" do
    get chefs_path
    assert_response :success
  end
  
  test "should get the chefs listing" do
    get chefs_path
    assert_template 'chefs/index'
    # search for links to the specific chef pages (a tags) - which are on the Chefs
    assert_select "a[href=?]", chef_path(@aChef), text: @aChef.chefname
    assert_select "a[href=?]", chef_path(@aChef2), text: @aChef2.chefname
    assert_match "1 recipe", response.body
    assert_match "0 recipes", response.body
  end
  
  test "should delete chef" do
    get chefs_path
    assert_template 'chefs/index'
    assert_difference 'Chef.count', -1 do
      delete chef_path(@aChef2)
    end
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
end
