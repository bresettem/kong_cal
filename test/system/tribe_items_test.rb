require "application_system_test_case"

class TribeItemsTest < ApplicationSystemTestCase
  setup do
    @tribe_item = tribe_items(:one)
  end

  test "visiting the index" do
    visit tribe_items_url
    assert_selector "h1", text: "Tribe items"
  end

  test "should create tribe item" do
    visit tribe_items_url
    click_on "New tribe item"

    fill_in "Daily yield", with: @tribe_item.daily_yield
    fill_in "Item", with: @tribe_item.item
    fill_in "Owned", with: @tribe_item.owned
    fill_in "Price", with: @tribe_item.price
    click_on "Create Tribe item"

    assert_text "Tribe item was successfully created"
    click_on "Back"
  end

  test "should update Tribe item" do
    visit tribe_item_url(@tribe_item)
    click_on "Edit this tribe item", match: :first

    fill_in "Daily yield", with: @tribe_item.daily_yield
    fill_in "Item", with: @tribe_item.item
    fill_in "Owned", with: @tribe_item.owned
    fill_in "Price", with: @tribe_item.price
    click_on "Update Tribe item"

    assert_text "Tribe item was successfully updated"
    click_on "Back"
  end

  test "should destroy Tribe item" do
    visit tribe_item_url(@tribe_item)
    click_on "Destroy this tribe item", match: :first

    assert_text "Tribe item was successfully destroyed"
  end
end
