require "test_helper"

class DeliveriesControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
  setup do
    @delivery = deliveries(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get deliveries_url
    assert_response :success
  end

  test "should get new" do
    get new_delivery_url
    assert_response :success
  end

  test "should create delivery" do
    assert_difference("Delivery.count") do
      post deliveries_url, params: { delivery: { 
        origin_leave: @delivery.origin_leave,
        schedule_id: @delivery.schedule_id,
        origin_address: @delivery.origin_address,
        origin_lat: @delivery.origin_lat,
        origin_lon: @delivery.origin_lon,
        dest_address: @delivery.dest_address,
        dest_lat: @delivery.dest_lat,
        dest_lon: @delivery.dest_lon,
        dest_arrive: @delivery.dest_arrive,
        dest_leave: @delivery.dest_leave
      } }
    end

    assert_redirected_to delivery_url(Delivery.last)
  end

  test "should show delivery" do
    get delivery_url(@delivery)
    assert_response :success
  end

  test "should get edit" do
    get edit_delivery_url(@delivery)
    assert_response :success
  end

  test "should update delivery" do
    patch delivery_url(@delivery), params: { delivery: { 
      origin_leave: @delivery.origin_leave,
      schedule_id: @delivery.schedule_id,
      origin_address: @delivery.origin_address,
      origin_lat: @delivery.origin_lat,
      origin_lon: @delivery.origin_lon,
      dest_address: @delivery.dest_address,
      dest_lat: @delivery.dest_lat,
      dest_lon: @delivery.dest_lon,
      dest_arrive: @delivery.dest_arrive,
      dest_leave: @delivery.dest_leave
    } }
    assert_redirected_to delivery_url(@delivery)
  end

  test "should destroy delivery" do
    assert_difference("Delivery.count", -1) do
      delete delivery_url(@delivery)
    end

    assert_redirected_to deliveries_url
  end
end
