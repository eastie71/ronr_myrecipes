require 'test_helper'

class ChefSignupTest < ActionDispatch::IntegrationTest
  test "should get chef signup path" do
    get signup_path
    assert_response :success
  end
  
  test "reject an invalid signup" do
    get signup_path
    assert_template 'chefs/new'
    # Check to see if the count of the number of chefs increases, when trying to post an invalid chef
    assert_no_difference 'Chef.count' do
      post chefs_path, params: { chef: {chefname: " ", email: " ", password: "password", password_confirmation: " "}}
    end
    assert_template 'chefs/new'
    # Check for panel-title and panel-body in the HTML - this will appear if any errors occur
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end
  
  test "accept and create a valid signup account" do
    get signup_path
    assert_template 'chefs/new'
    # Check to see if the count of the number of chefs increases, when trying to post a valid chef
    assert_difference 'Chef.count' do
      post chefs_path, params: { chef: {chefname: "Craig", email: "craig@test.com", password: "password", password_confirmation: "password"}}
    end
    # Should go to show page after create
    follow_redirect!
    assert_template 'chefs/show'
    # Check for flash message of successful create
    assert_not flash.empty?
  end
end
