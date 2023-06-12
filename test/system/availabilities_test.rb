require "application_system_test_case"

class AvailabilitiesTest < ApplicationSystemTestCase
  setup do
    @availability = availabilities(:one)
  end

  test "visiting the index" do
    visit availabilities_url
    assert_selector "h1", text: "Availabilities"
  end

  test "should create availability" do
    visit availabilities_url
    click_on "New availability"

    fill_in "End time", with: @availability.end_time
    fill_in "Start time", with: @availability.start_time
    fill_in "User", with: @availability.user_id
    click_on "Create Availability"

    assert_text "Availability was successfully created"
    click_on "Back"
  end

  test "should update Availability" do
    visit availability_url(@availability)
    click_on "Edit this availability", match: :first

    fill_in "End time", with: @availability.end_time
    fill_in "Start time", with: @availability.start_time
    fill_in "User", with: @availability.user_id
    click_on "Update Availability"

    assert_text "Availability was successfully updated"
    click_on "Back"
  end

  test "should destroy Availability" do
    visit availability_url(@availability)
    click_on "Destroy this availability", match: :first

    assert_text "Availability was successfully destroyed"
  end
end
