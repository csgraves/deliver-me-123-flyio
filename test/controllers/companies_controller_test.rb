require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
  setup do
    @company = companies(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get companies_url
    assert_response :success
  end

  test "should get new" do
    get new_company_url
    assert_response :success
  end

  test "should create company" do
    assert_difference("Company.count") do
      post companies_url, params: { company: { company_iden: @company.company_iden, name: @company.name } }
    end

    assert_redirected_to user_dashboard_url()
  end

  test "should show company" do
    get company_url(@company)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_url(@company)
    assert_response :success
  end

  test "should update company" do
    patch company_url(@company), params: { company: { company_iden: @company.company_iden, name: @company.name } }
    assert_redirected_to company_url(@company)
  end

  test "should destroy company" do
    assert_difference("Company.count", -1) do
      delete company_url(@company)
    end

    assert_redirected_to companies_url
  end
  
  test "should redirect unauthorised users" do
    sign_out users(:one)
    sign_in users(:two)

    get company_url(@company)
    assert_redirected_to root_url
    assert_equal "You do not have permission to access this page.", flash[:alert]

    get edit_company_url(@company)
    assert_redirected_to root_url
    assert_equal "You do not have permission to access this page.", flash[:alert]

    patch company_url(@company), params: { company: { name: "New Name" } }
    assert_redirected_to root_url
    assert_equal "You do not have permission to access this page.", flash[:alert]

    delete company_url(@company)
    assert_redirected_to root_url
    assert_equal "You do not have permission to access this page.", flash[:alert]
  end
  
end
