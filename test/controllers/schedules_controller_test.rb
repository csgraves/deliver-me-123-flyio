require "test_helper"

class SchedulesControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
  setup do
    @schedule = schedules(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get schedules_url
    assert_response :success
  end

  test "should get new" do
    get new_schedule_url
    assert_response :success
  end

  test "should create schedule" do
    assert_difference("Schedule.count") do
      post schedules_url, params: { schedule: { branch_id: @schedule.branch_id, branch_only: @schedule.branch_only, end_time: @schedule.end_time, start_time: @schedule.start_time, user_id: @schedule.user_id, user_only: @schedule.user_only } }
    end

    assert_redirected_to schedule_url(Schedule.last)
  end

  test "should show schedule" do
    get schedule_url(@schedule)
    assert_response :success
  end

  test "should get edit" do
    get edit_schedule_url(@schedule)
    assert_response :success
  end

  test "should update schedule" do
    patch schedule_url(@schedule), params: { schedule: { branch_id: @schedule.branch_id, branch_only: @schedule.branch_only, end_time: @schedule.end_time, start_time: @schedule.start_time, user_id: @schedule.user_id, user_only: @schedule.user_only } }
    assert_redirected_to schedule_url(@schedule)
  end

  test "should destroy schedule" do
    assert_difference("Schedule.count", -1) do
      delete schedule_url(@schedule)
    end

    assert_redirected_to schedules_url
  end
end
