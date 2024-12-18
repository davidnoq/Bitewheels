# test/controllers/users_controller_test.rb
require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user_one = User.create!(
      email: 'user1@example.com',
      password: 'password1',
      password_confirmation: 'password1',
      first_name: 'User',
      last_name: 'One',
      phone_number: '123-456-7890'
    )

    @user_two = User.create!(
      email: 'user2@example.com',
      password: 'password2',
      password_confirmation: 'password2',
      first_name: 'User',
      last_name: 'Two',
      phone_number: '098-765-4321'
    )
  end

  # 1. Test for showing the signed-in user's profile
  test "should show own profile" do
    sign_in @user_one
    get user_profile_path
    assert_response :success
    
  end

 # Updated Test for Showing Another User's Profile
test "should not show another user's profile" do
  sign_in @user_one
  get user_path(@user_two) # Trying to access user_two's profile using a RESTful route
  assert_redirected_to root_path
  follow_redirect!
  assert_match /You are not authorized to perform this action./, response.body
end


  # 3. Test for editing the signed-in user's profile using Devise's edit route
  test "should get Devise edit page for own profile" do
    sign_in @user_one
    get edit_user_registration_path
    assert_response :success
   
  end

 

  # 5. Test for redirecting unauthorized user trying to edit another user's profile
  test "should not edit another user's profile" do
    sign_in @user_one
    get edit_user_registration_path(@user_two) # Devise's edit path should not allow this
    assert_redirected_to root_path
    follow_redirect!
    assert_match /You are not authorized to perform this action./, response.body
  end

 

 

  


  # 10. Test for preventing unauthenticated users from accessing the edit page
  test "should redirect unauthenticated user to sign in when trying to edit profile" do
    get edit_user_registration_path
    assert_redirected_to new_user_session_path
  end
end
