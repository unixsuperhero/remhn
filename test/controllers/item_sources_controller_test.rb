require "test_helper"

class ItemSourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item_source = item_sources(:one)
  end

  test "should get index" do
    get item_sources_url
    assert_response :success
  end

  test "should get new" do
    get new_item_source_url
    assert_response :success
  end

  test "should create item_source" do
    assert_difference("ItemSource.count") do
      post item_sources_url, params: { item_source: { item_id: @item_source.item_id, source_id: @item_source.source_id, source_type: @item_source.source_type, stars: @item_source.stars } }
    end

    assert_redirected_to item_source_url(ItemSource.last)
  end

  test "should show item_source" do
    get item_source_url(@item_source)
    assert_response :success
  end

  test "should get edit" do
    get edit_item_source_url(@item_source)
    assert_response :success
  end

  test "should update item_source" do
    patch item_source_url(@item_source), params: { item_source: { item_id: @item_source.item_id, source_id: @item_source.source_id, source_type: @item_source.source_type, stars: @item_source.stars } }
    assert_redirected_to item_source_url(@item_source)
  end

  test "should destroy item_source" do
    assert_difference("ItemSource.count", -1) do
      delete item_source_url(@item_source)
    end

    assert_redirected_to item_sources_url
  end
end
