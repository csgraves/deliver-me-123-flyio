require "application_system_test_case"

class LessonPaymentsTest < ApplicationSystemTestCase
  setup do
    @lesson_payment = lesson_payments(:one)
  end

  test "visiting the index" do
    visit lesson_payments_url
    assert_selector "h1", text: "Lesson payments"
  end

  test "should create lesson payment" do
    visit lesson_payments_url
    click_on "New lesson payment"

    fill_in "Account", with: @lesson_payment.account_id
    fill_in "Booking", with: @lesson_payment.booking_id
    fill_in "Cost", with: @lesson_payment.cost
    fill_in "Date", with: @lesson_payment.date
    fill_in "Payment number", with: @lesson_payment.payment_number
    fill_in "Service", with: @lesson_payment.service
    fill_in "Status", with: @lesson_payment.status
    click_on "Create Lesson payment"

    assert_text "Lesson payment was successfully created"
    click_on "Back"
  end

  test "should update Lesson payment" do
    visit lesson_payment_url(@lesson_payment)
    click_on "Edit this lesson payment", match: :first

    fill_in "Account", with: @lesson_payment.account_id
    fill_in "Booking", with: @lesson_payment.booking_id
    fill_in "Cost", with: @lesson_payment.cost
    fill_in "Date", with: @lesson_payment.date
    fill_in "Payment number", with: @lesson_payment.payment_number
    fill_in "Service", with: @lesson_payment.service
    fill_in "Status", with: @lesson_payment.status
    click_on "Update Lesson payment"

    assert_text "Lesson payment was successfully updated"
    click_on "Back"
  end

  test "should destroy Lesson payment" do
    visit lesson_payment_url(@lesson_payment)
    click_on "Destroy this lesson payment", match: :first

    assert_text "Lesson payment was successfully destroyed"
  end
end
