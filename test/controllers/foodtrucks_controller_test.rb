require "test_helper"

class FoodtrucksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @foodtruck = foodtrucks(:one)
  end

  test "should get index" do
    get foodtrucks_url
    assert_response :success
  end

  test "should get new" do
    get new_foodtruck_url
    assert_response :success
  end

  test "should create foodtruck" do
    assert_difference("Foodtruck.count") do
      post foodtrucks_url, params: { foodtruck: {} }
    end

    assert_redirected_to foodtruck_url(Foodtruck.last)
  end

  test "should show foodtruck" do
    get foodtruck_url(@foodtruck)
    assert_response :success
  end

  test "should get edit" do
    get edit_foodtruck_url(@foodtruck)
    assert_response :success
  end

  test "should update foodtruck" do
    patch foodtruck_url(@foodtruck), params: { foodtruck: {} }
    assert_redirected_to foodtruck_url(@foodtruck)
  end

  test "should destroy foodtruck" do
    assert_difference("Foodtruck.count", -1) do
      delete foodtruck_url(@foodtruck)
    end

    assert_redirected_to foodtrucks_url
  end
end
