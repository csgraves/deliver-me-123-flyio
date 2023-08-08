require "test_helper"

class BranchesControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
  setup do
    @branch = branches(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get branches_url
    assert_response :success
  end

  test "should get new" do
    get new_branch_url
    assert_response :success
  end

  test "should create branch" do
    assert_difference("Branch.count") do
      post branches_url, params: { branch: { branch_iden: @branch.branch_iden, company_iden: @branch.company_iden, name: @branch.name } }
    end

    assert_redirected_to branch_url(Branch.last)
  end

  test "should show branch" do
    get branch_url(@branch)
    assert_response :success
  end

  test "should get edit" do
    get edit_branch_url(@branch)
    assert_response :success
  end

  test "should update branch" do
    patch branch_url(@branch), params: { branch: { branch_iden: @branch.branch_iden, company_iden: @branch.company_iden, name: @branch.name } }
    assert_redirected_to branch_url(@branch)
  end

  test "should destroy branch" do
    assert_difference("Branch.count", -1) do
      delete branch_url(@branch)
    end

    assert_redirected_to companies_url
  end

  test "should redirect to login when unauthenticated user tries to access new branch form" do
    sign_out users(:one)
    get new_branch_url
    assert_redirected_to new_user_session_url
  end

  test "should only allow authorized users to create branches" do
    sign_out users(:one)
    unauthorized_user = users(:two)
    sign_in unauthorized_user

    assert_no_difference("Branch.count") do
      post branches_url, params: { branch: { branch_iden: @branch.branch_iden, company_iden: @branch.company_iden, name: @branch.name, company_id: @branch.company_id } }
    end

    assert_redirected_to root_url
  end

  test "should not create branch with invalid attributes" do
    assert_no_difference("Branch.count") do
      post branches_url, params: { branch: { branch_iden: @branch.branch_iden, company_iden: @branch.company_iden, name: nil, company_id: @branch.company_id } }
    end
  end

  test "should destroy branch and its associated records" do
    assert_difference("Branch.count", -1) do
      assert_difference("Schedule.count", -1) do
         delete branch_url(@branch)
      end
    end

    assert_redirected_to companies_url
  end

  test "non-admin / authorised user should not access edit, update, and destroy actions" do
    sign_out users(:one)
    unauthorized_user = users(:two)
    sign_in unauthorized_user
  
    get new_branch_url
    assert_redirected_to root_url
    assert_equal "You do not have permission.", flash[:alert]

    assert_no_difference("Branch.count") do
      post branches_url, params: { branch: { name: "New Branch", branch_iden: "new-branch", company_iden: "new-company", company_id: @branch.company_id } }
    end
    assert_redirected_to root_url
    assert_equal "You do not have permission.", flash[:alert]

    get edit_branch_url(@branch)
    assert_redirected_to root_url
    assert_equal "You do not have permission to access this page.", flash[:alert]

    patch branch_url(@branch), params: { branch: { name: "Updated Branch", branch_iden: @branch.branch_iden, company_iden: @branch.company_iden, company_id: @branch.company_id } }
    assert_redirected_to root_url
    assert_equal "You do not have permission to access this page.", flash[:alert]

    assert_no_difference("Branch.count") do
      delete branch_url(@branch)
    end
    assert_redirected_to root_url
    assert_equal "You do not have permission to access this page.", flash[:alert]
  end

  test "should not show branch not associated with current user's branch_id or company if user is driver" do
    sign_out users(:one)
    unauthorized_user = users(:two)
    sign_in unauthorized_user
    
    another_branch = branches(:one)
    get branch_url(another_branch)
    assert_redirected_to root_url
    assert_equal "You do not have permission.", flash[:alert]
  end

end
