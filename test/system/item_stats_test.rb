require "application_system_test_case"

class ItemStatsTest < ApplicationSystemTestCase
  setup do
    @item_stat = item_stats(:one)
  end

  test "visiting the index" do
    visit item_stats_url
    assert_selector "h1", text: "Item stats"
  end

  test "should create item stat" do
    visit item_stats_url
    click_on "New item stat"

    fill_in "Equipable stat", with: @item_stat.equipable_stat_id
    fill_in "Item", with: @item_stat.item_id
    fill_in "Qty", with: @item_stat.qty
    click_on "Create Item stat"

    assert_text "Item stat was successfully created"
    click_on "Back"
  end

  test "should update Item stat" do
    visit item_stat_url(@item_stat)
    click_on "Edit this item stat", match: :first

    fill_in "Equipable stat", with: @item_stat.equipable_stat_id
    fill_in "Item", with: @item_stat.item_id
    fill_in "Qty", with: @item_stat.qty
    click_on "Update Item stat"

    assert_text "Item stat was successfully updated"
    click_on "Back"
  end

  test "should destroy Item stat" do
    visit item_stat_url(@item_stat)
    click_on "Destroy this item stat", match: :first

    assert_text "Item stat was successfully destroyed"
  end
end
