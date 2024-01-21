require "application_system_test_case"

class ForgeItemsTest < ApplicationSystemTestCase
  setup do
    @forge_item = forge_items(:one)
  end

  test "visiting the index" do
    visit forge_items_url
    assert_selector "h1", text: "Forge items"
  end

  test "should create forge item" do
    visit forge_items_url
    click_on "New forge item"

    fill_in "Equipable", with: @forge_item.equipable_id
    fill_in "Item", with: @forge_item.item_id
    fill_in "Level", with: @forge_item.level_id
    fill_in "Qty", with: @forge_item.qty
    click_on "Create Forge item"

    assert_text "Forge item was successfully created"
    click_on "Back"
  end

  test "should update Forge item" do
    visit forge_item_url(@forge_item)
    click_on "Edit this forge item", match: :first

    fill_in "Equipable", with: @forge_item.equipable_id
    fill_in "Item", with: @forge_item.item_id
    fill_in "Level", with: @forge_item.level_id
    fill_in "Qty", with: @forge_item.qty
    click_on "Update Forge item"

    assert_text "Forge item was successfully updated"
    click_on "Back"
  end

  test "should destroy Forge item" do
    visit forge_item_url(@forge_item)
    click_on "Destroy this forge item", match: :first

    assert_text "Forge item was successfully destroyed"
  end
end
