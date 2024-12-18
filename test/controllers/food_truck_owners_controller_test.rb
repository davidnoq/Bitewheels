require "test_helper"

class FoodTruckOwnersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @food_truck_owner = food_truck_owners(:one)
  end

  test "should get index" do
    get food_truck_owners_url
    assert_response :success
  end

  test "should get new" do
    get new_food_truck_owner_url
    assert_response :success
  end

  test "should create food_truck_owner" do
    assert_difference("FoodTruckOwner.count") do
      post food_truck_owners_url, params: { food_truck_owner: {} }
    end

    assert_redirected_to food_truck_owner_url(FoodTruckOwner.last)
  end

  test "should show food_truck_owner" do
    get food_truck_owner_url(@food_truck_owner)
    assert_response :success
  end

  test "should get edit" do
    get edit_food_truck_owner_url(@food_truck_owner)
    assert_response :success
  end

  test "should update food_truck_owner" do
    patch food_truck_owner_url(@food_truck_owner), params: { food_truck_owner: {} }
    assert_redirected_to food_truck_owner_url(@food_truck_owner)
  end

  test "should destroy food_truck_owner" do
    assert_difference("FoodTruckOwner.count", -1) do
      delete food_truck_owner_url(@food_truck_owner)
    end

    assert_redirected_to food_truck_owners_url
  end
end
