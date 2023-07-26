require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @user_no_schedule = users(:no_schedule)
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be saved in lowercase" do
    mixed_case_email = "User@example.com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present" do
    @user.password_digest = ""
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password_digest = "a" * 5
    assert_not @user.valid?
  end

  test "role should be present" do
    @user.role = ""
    assert_not @user.valid?
  end

  test "should belong to a branch" do
    @user.branch = nil
    assert_not @user.valid?
  end

  test "user without schedule should not have delivery" do
    assert_nil @user_no_schedule.schedule
    assert_empty @user_no_schedule.deliveries
  end
end
