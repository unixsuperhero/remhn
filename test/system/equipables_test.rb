require "application_system_test_case"

class EquipablesTest < ApplicationSystemTestCase
  setup do
    @equipable = equipables(:one)
  end

  test "visiting the index" do
    visit equipables_url
    assert_selector "h1", text: "Equipables"
  end

  test "should create equipable" do
    visit equipables_url
    click_on "New equipable"

    fill_in "Group", with: @equipable.group
    fill_in "Monster", with: @equipable.monster_id
    fill_in "Subgroup", with: @equipable.subgroup
    click_on "Create Equipable"

    assert_text "Equipable was successfully created"
    click_on "Back"
  end

  test "should update Equipable" do
    visit equipable_url(@equipable)
    click_on "Edit this equipable", match: :first

    fill_in "Group", with: @equipable.group
    fill_in "Monster", with: @equipable.monster_id
    fill_in "Subgroup", with: @equipable.subgroup
    click_on "Update Equipable"

    assert_text "Equipable was successfully updated"
    click_on "Back"
  end

  test "should destroy Equipable" do
    visit equipable_url(@equipable)
    click_on "Destroy this equipable", match: :first

    assert_text "Equipable was successfully destroyed"
  end
end
