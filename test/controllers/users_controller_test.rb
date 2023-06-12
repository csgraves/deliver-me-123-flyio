require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:two)
    #sign_in users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

=begin
  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { branch_id: @user.branch_id, email: @user.email, name: 
      @user.name, role: @user.role } }
    end

    assert_redirected_to user_url(User.last)
  end
=end 

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

=begin
  test "should update user" do
    patch user_url(@user), params: { user: { branch_id: @user.branch_id, email: @user.email, name: @user.name, role: @user.role } }
    assert_redirected_to user_url(@user)
  end
=end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
