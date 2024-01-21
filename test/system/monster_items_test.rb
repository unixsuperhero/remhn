require "application_system_test_case"

class MonsterItemsTest < ApplicationSystemTestCase
  setup do
    @monster_item = monster_items(:one)
  end

  test "visiting the index" do
    visit monster_items_url
    assert_selector "h1", text: "Monster items"
  end

  test "should create monster item" do
    visit monster_items_url
    click_on "New monster item"

    fill_in "Grade", with: @monster_item.grade
    fill_in "Item", with: @monster_item.item_id
    fill_in "Monster", with: @monster_item.monster_id
    click_on "Create Monster item"

    assert_text "Monster item was successfully created"
    click_on "Back"
  end

  test "should update Monster item" do
    visit monster_item_url(@monster_item)
    click_on "Edit this monster item", match: :first

    fill_in "Grade", with: @monster_item.grade
    fill_in "Item", with: @monster_item.item_id
    fill_in "Monster", with: @monster_item.monster_id
    click_on "Update Monster item"

    assert_text "Monster item was successfully updated"
    click_on "Back"
  end

  test "should destroy Monster item" do
    visit monster_item_url(@monster_item)
    click_on "Destroy this monster item", match: :first

    assert_text "Monster item was successfully destroyed"
  end
end
