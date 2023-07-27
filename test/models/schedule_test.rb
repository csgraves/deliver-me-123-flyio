require "test_helper"

class ScheduleTest < ActiveSupport::TestCase
  test "schedule with user should be valid" do
    user = users(:one)  # Assuming you have fixture data for users
    schedule = Schedule.new(start_time: Time.now, end_time: Time.now + 1.hour, user: user)
    assert schedule.valid?
  end

  test "schedule with branch should be valid" do
    branch = branches(:one)  # Assuming you have fixture data for branches
    schedule = Schedule.new(start_time: Time.now, end_time: Time.now + 1.hour, branch: branch)
    assert schedule.valid?
  end

  test "schedule without user or branch should be invalid" do
    schedule = Schedule.new(start_time: Time.now, end_time: Time.now + 1.hour)
    assert_not schedule.valid?
    assert_includes schedule.errors[:base], "Schedule must belong to a user or a branch"
  end
end
