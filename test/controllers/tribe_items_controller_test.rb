require "test_helper"

class TribeItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tribe_item = tribe_items(:one)
  end

  test "should get index" do
    get tribe_items_url
    assert_response :success
  end

  test "should get new" do
    get new_tribe_item_url
    assert_response :success
  end

  test "should create tribe_item" do
    assert_difference("TribeItem.count") do
      post tribe_items_url, params: { tribe_item: { daily_yield: @tribe_item.daily_yield, item: @tribe_item.item, owned: @tribe_item.owned, price: @tribe_item.price } }
    end

    assert_redirected_to tribe_item_url(TribeItem.last)
  end

  test "should show tribe_item" do
    get tribe_item_url(@tribe_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_tribe_item_url(@tribe_item)
    assert_response :success
  end

  test "should update tribe_item" do
    patch tribe_item_url(@tribe_item), params: { tribe_item: { daily_yield: @tribe_item.daily_yield, item: @tribe_item.item, owned: @tribe_item.owned, price: @tribe_item.price } }
    assert_redirected_to tribe_item_url(@tribe_item)
  end

  test "should destroy tribe_item" do
    assert_difference("TribeItem.count", -1) do
      delete tribe_item_url(@tribe_item)
    end

    assert_redirected_to tribe_items_url
  end
end
