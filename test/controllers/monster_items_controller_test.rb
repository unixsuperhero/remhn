require "test_helper"

class MonsterItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @monster_item = monster_items(:one)
  end

  test "should get index" do
    get monster_items_url
    assert_response :success
  end

  test "should get new" do
    get new_monster_item_url
    assert_response :success
  end

  test "should create monster_item" do
    assert_difference("MonsterItem.count") do
      post monster_items_url, params: { monster_item: { grade: @monster_item.grade, item_id: @monster_item.item_id, monster_id: @monster_item.monster_id } }
    end

    assert_redirected_to monster_item_url(MonsterItem.last)
  end

  test "should show monster_item" do
    get monster_item_url(@monster_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_monster_item_url(@monster_item)
    assert_response :success
  end

  test "should update monster_item" do
    patch monster_item_url(@monster_item), params: { monster_item: { grade: @monster_item.grade, item_id: @monster_item.item_id, monster_id: @monster_item.monster_id } }
    assert_redirected_to monster_item_url(@monster_item)
  end

  test "should destroy monster_item" do
    assert_difference("MonsterItem.count", -1) do
      delete monster_item_url(@monster_item)
    end

    assert_redirected_to monster_items_url
  end
end
