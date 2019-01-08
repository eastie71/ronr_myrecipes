require 'test_helper'

class ChefEditTest < ActionDispatch::IntegrationTest
  def setup
    @aChef = Chef.create!(chefname: "Craig", email: "cde@mail.com.au",
                            password: "password", password_confirmation: "password")
    @admin_chef = Chef.create!(chefname: "Admin", email: "admin@mail.com.au",
                            password: "password", password_confirmation: "password", admin: true)
    @non_admin_chef = Chef.create!(chefname: "NonAdmin", email: "nonadmin@mail.com.au",
                            password: "password", password_confirmation: "password", admin: false)
    @aRecipe = Recipe.create!(name: "Best bbq bangers", description: "awesome bbq sausages.", chef: @aChef)
  end
  
  test "reject an invalid chef edit" do
    sign_in_as(@aChef, @aChef.password)
    get edit_chef_path(@aChef)
    assert_template 'chefs/edit'
    patch chef_path(@aChef), params: { chef: {chefname: " ", email: "cde@mail.com.au"} }
    assert_template 'chefs/edit'
    # Check for panel-title and panel-body in the HTML - this will appear if any errors occur
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end
  
  test "accept and save a valid chef edit" do
    sign_in_as(@aChef, @aChef.password)
    get edit_chef_path(@aChef)
    assert_template 'chefs/edit'
    patch chef_path(@aChef), params: { chef: {chefname: "Craig2", email: "cde2@mail.com.au"} }
    # Should go to show page after edit
    assert_redirected_to @aChef
    # Check for flash message of successful edit
    assert_not flash.empty?
    @aChef.reload
    assert_match "Craig2", @aChef.chefname
    assert_match "cde2@mail.com.au", @aChef.email
  end
  
  test "accept edit by admin chef" do
    sign_in_as(@admin_chef, @admin_chef.password)
    get edit_chef_path(@aChef)
    assert_template 'chefs/edit'
    patch chef_path(@aChef), params: { chef: {chefname: "Craig2", email: "cde2@mail.com.au"} }
    # Should go to show page after edit
    assert_redirected_to @aChef
    # Check for flash message of successful edit
    assert_not flash.empty?
    @aChef.reload
    assert_match "Craig2", @aChef.chefname
    assert_match "cde2@mail.com.au", @aChef.email
  end
  
  test "reject edit by non-admin chef" do
    sign_in_as(@non_admin_chef, @non_admin_chef.password)
    patch chef_path(@aChef), params: { chef: {chefname: "Craig3", email: "cde3@mail.com.au"} }
    assert_redirected_to chef_path(@non_admin_chef)
    assert_not flash.empty?
    @aChef.reload
    assert_match "Craig", @aChef.chefname
    assert_match "cde@mail.com.au", @aChef.email
  end
end
