require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:two)
    #sign_in users(:one)
  end

  test "should get index" do
    @user = users(:one)
    sign_in users(:one)
    get users_url
    assert_response :success
  end

  test "should get new" do
    @user = users(:one)
    sign_in users(:one)
    get new_user_url
    assert_redirected_to root_path
  end

  test "should redirect to root for non-admin trying to access new user page" do
    sign_in users(:two)
    get new_user_url
    assert_redirected_to root_path
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
    @user = users(:one)
    sign_in users(:one)
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    @user = users(:one)
    sign_in users(:one)
    get edit_user_url(@user)
    assert_response :success
  end

  test "should not update user for non-admin" do
    @user = users(:two)
    sign_in users(:two)
    patch user_url(@user), params: { user: { name: "Updated Name" } }
    assert_redirected_to root_path
    @user.reload
    assert_not_equal "Updated Name", @user.name
  end

=begin
  test "should update user" do
    patch user_url(@user), params: { user: { branch_id: @user.branch_id, email: @user.email, name: @user.name, role: @user.role } }
    assert_redirected_to user_url(@user)
  end
=end

  test "should destroy user" do
    @user = users(:one)
    sign_in users(:one)
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end

  test "should not destroy user for non-admin" do
    @user = users(:two)
    sign_in users(:two)
    assert_no_difference("User.count") do
      delete user_url(@user)
    end
    assert_redirected_to root_path
  end
end
