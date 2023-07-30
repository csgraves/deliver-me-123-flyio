require "test_helper"

class AvailabilitiesControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

  setup do
    @availability = availabilities(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get availabilities_url
    assert_response :success
  end

  test "should get new" do
    get new_availability_url
    assert_response :success
  end

  test "should create availability" do
    assert_difference("Availability.count") do
      post availabilities_url, params: { availability: { end_time: @availability.end_time, start_time: @availability.start_time, user_id: @availability.user_id } }
    end

    assert_redirected_to availability_url(Availability.last)
  end

  test "should show availability" do
    get availability_url(@availability)
    assert_response :success
  end

  test "should get edit" do
    get edit_availability_url(@availability)
    assert_response :success
  end

  test "should update availability" do
    patch availability_url(@availability), params: { availability: { end_time: @availability.end_time, start_time: @availability.start_time, user_id: @availability.user_id } }
    assert_redirected_to availability_url(@availability)
  end

  test "should destroy availability" do
    assert_difference("Availability.count", -1) do
      delete availability_url(@availability)
    end

    assert_redirected_to availabilities_url
  end

  test "should not get edit when not authorized" do
    sign_out users(:one)
    sign_in users(:two)
    get edit_availability_url(@availability)
    assert_redirected_to root_url
  end

  test "should not update availability when not authorized" do
    sign_out users(:one)
    sign_in users(:two)
    patch availability_url(@availability), params: { availability: { end_time: @availability.end_time, start_time: @availability.start_time, user_id: @availability.user_id } }
    assert_redirected_to root_url
  end

  test "should not destroy availability when not authorized" do
    sign_out users(:one)
    sign_in users(:two)
    assert_no_difference("Availability.count") do
      delete availability_url(@availability)
    end
    assert_redirected_to root_url
  end
end
