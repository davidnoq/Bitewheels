require "application_system_test_case"

class FoodtrucksTest < ApplicationSystemTestCase
  setup do
    @foodtruck = foodtrucks(:one)
  end

  test "visiting the index" do
    visit foodtrucks_url
    assert_selector "h1", text: "Foodtrucks"
  end

  test "should create foodtruck" do
    visit foodtrucks_url
    click_on "New foodtruck"

    click_on "Create Foodtruck"

    assert_text "Foodtruck was successfully created"
    click_on "Back"
  end

  test "should update Foodtruck" do
    visit foodtruck_url(@foodtruck)
    click_on "Edit this foodtruck", match: :first

    click_on "Update Foodtruck"

    assert_text "Foodtruck was successfully updated"
    click_on "Back"
  end

  test "should destroy Foodtruck" do
    visit foodtruck_url(@foodtruck)
    click_on "Destroy this foodtruck", match: :first

    assert_text "Foodtruck was successfully destroyed"
  end
end
