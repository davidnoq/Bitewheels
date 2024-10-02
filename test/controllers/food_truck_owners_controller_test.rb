require "test_helper"

class FoodTruckOwnersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get food_truck_owners_index_url
    assert_response :success
  end

  test "should get show" do
    get food_truck_owners_show_url
    assert_response :success
  end

  test "should get new" do
    get food_truck_owners_new_url
    assert_response :success
  end

  test "should get edit" do
    get food_truck_owners_edit_url
    assert_response :success
  end

  test "should get create" do
    get food_truck_owners_create_url
    assert_response :success
  end

  test "should get update" do
    get food_truck_owners_update_url
    assert_response :success
  end

  test "should get destroy" do
    get food_truck_owners_destroy_url
    assert_response :success
  end
end
