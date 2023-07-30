require "test_helper"

class AvailabilityTest < ActiveSupport::TestCase
  def setup
    @user = users(:one) # Assuming you have a fixture named 'one' in users.yml
    @availability = availabilities(:one)
  end

  test "should be valid" do
    assert @availability.valid?
  end

  test "start_time should be present" do
    @availability.start_time = nil
    assert_not @availability.valid?
  end

  test "end_time should be present" do
    @availability.end_time = nil
    assert_not @availability.valid?
  end

  test "should belong to a user" do
    assert_instance_of User, @availability.user
  end

  test "should save availability" do
    @availability = Availability.new(
      start_time: Time.now,
      end_time: Time.now + 1.hour,
      user: @user
    )
    assert_difference('Availability.count', 1) do
      @availability.save
    end
  end

  test "should update availability" do
    @availability.save
    new_start_time = Time.now + 2.hours
    @availability.update(start_time: new_start_time)
    assert_equal new_start_time.change(usec: 0), @availability.reload.start_time.change(usec: 0)
  end

  test "should destroy availability" do
    @availability.save
    assert_difference('Availability.count', -1) do
      @availability.destroy
    end
  end
end
