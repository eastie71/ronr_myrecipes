require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.new(chefname: "Craig Eastwood", email: "craig@test.com",
                      password: "password", password_confirmation: "password")
  end
  
  test "Chef should be validate" do
    assert @chef.valid?
  end
  
  test "name cannot be blank" do
    @chef.chefname = ""
    assert_not @chef.valid?
  end
  
  test "email cannot be blank" do
    @chef.email = ""
    assert_not @chef.valid?
  end
  
  test "name size less than max length" do
    @chef.chefname = "A" * 61
    assert_not @chef.valid?
  end
  
  test "email size less than max length" do
    @chef.chefname = "A" * 300
    assert_not @chef.valid?
  end
  
  test "email should accept correct email addresses" do
    valid_emails = %w[craig@example.com abc.123@fred.com.au whatthe+f@test.org.uk jj.kk@sfx.vic.gov.edu.au]
    valid_emails.each do |valid_email|
      @chef.email = valid_email
      assert @chef.valid?, "#{valid_email.inspect} should be valid"
    end
  end
  
  test "email should reject invalid email addresses" do
    invalid_emails = %w[craig@example abc.123@@fred.com.au whatthe+f#test.org.uk jj.kk@sfx.vic. wow@foo+bar.com]
    invalid_emails.each do |invalid_email|
      @chef.email = invalid_email
      assert_not @chef.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end
  
  test "email should be unique and case insensitive" do
    chef_copy = @chef.dup
    chef_copy.email = @chef.email.upcase
    @chef.save
    assert_not chef_copy.valid?
  end
  
  test "email should be lower case before saving to db" do
    mixed_email = "FreD@Gmail.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end
  
  test "password cannot be blank" do
    @chef.password = @chef.password_confirmation = " "
    assert_not @chef.valid?
  end
  
  test "password must be greater than minimum length" do
    @chef.password = @chef.password_confirmation = "x" * 4
    assert_not @chef.valid?
  end
end