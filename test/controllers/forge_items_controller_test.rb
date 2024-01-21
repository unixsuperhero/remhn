require "test_helper"

class ForgeItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @forge_item = forge_items(:one)
  end

  test "should get index" do
    get forge_items_url
    assert_response :success
  end

  test "should get new" do
    get new_forge_item_url
    assert_response :success
  end

  test "should create forge_item" do
    assert_difference("ForgeItem.count") do
      post forge_items_url, params: { forge_item: { equipable_id: @forge_item.equipable_id, item_id: @forge_item.item_id, level_id: @forge_item.level_id, qty: @forge_item.qty } }
    end

    assert_redirected_to forge_item_url(ForgeItem.last)
  end

  test "should show forge_item" do
    get forge_item_url(@forge_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_forge_item_url(@forge_item)
    assert_response :success
  end

  test "should update forge_item" do
    patch forge_item_url(@forge_item), params: { forge_item: { equipable_id: @forge_item.equipable_id, item_id: @forge_item.item_id, level_id: @forge_item.level_id, qty: @forge_item.qty } }
    assert_redirected_to forge_item_url(@forge_item)
  end

  test "should destroy forge_item" do
    assert_difference("ForgeItem.count", -1) do
      delete forge_item_url(@forge_item)
    end

    assert_redirected_to forge_items_url
  end
end
