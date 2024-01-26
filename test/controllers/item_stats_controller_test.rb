require "test_helper"

class ItemStatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item_stat = item_stats(:one)
  end

  test "should get index" do
    get item_stats_url
    assert_response :success
  end

  test "should get new" do
    get new_item_stat_url
    assert_response :success
  end

  test "should create item_stat" do
    assert_difference("ItemStat.count") do
      post item_stats_url, params: { item_stat: { equipable_stat_id: @item_stat.equipable_stat_id, item_id: @item_stat.item_id, qty: @item_stat.qty } }
    end

    assert_redirected_to item_stat_url(ItemStat.last)
  end

  test "should show item_stat" do
    get item_stat_url(@item_stat)
    assert_response :success
  end

  test "should get edit" do
    get edit_item_stat_url(@item_stat)
    assert_response :success
  end

  test "should update item_stat" do
    patch item_stat_url(@item_stat), params: { item_stat: { equipable_stat_id: @item_stat.equipable_stat_id, item_id: @item_stat.item_id, qty: @item_stat.qty } }
    assert_redirected_to item_stat_url(@item_stat)
  end

  test "should destroy item_stat" do
    assert_difference("ItemStat.count", -1) do
      delete item_stat_url(@item_stat)
    end

    assert_redirected_to item_stats_url
  end
end
