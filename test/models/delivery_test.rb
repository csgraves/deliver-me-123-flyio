require "test_helper"

class DeliveryTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @schedule = schedules(:one)

    availability = availabilities(:one)
    availability.start_time = Time.now - 1.day
    availability.end_time = Time.now + 1.day
    availability.save!

    @delivery = Delivery.new(
      origin_leave: Time.now,
      dest_arrive: Time.now + 1.hour,
      dest_leave: Time.now + 2.hours,
      schedule: @schedule
    )
  end

  test "should be valid" do
    assert @delivery.valid?
  end

  test "origin_leave should be present" do
    @delivery.origin_leave = nil
    assert_not @delivery.valid?
  end

  test "dest_arrive should be present" do
    @delivery.dest_arrive = nil
    assert_not @delivery.valid?
  end

  test "dest_leave should be present" do
    @delivery.dest_leave = nil
    assert_not @delivery.valid?
  end

  test "dest_leave should be greater than or equal to dest_arrive" do
    @delivery.dest_leave = @delivery.dest_arrive - 1.hour
    assert_not @delivery.valid?
  end
end
