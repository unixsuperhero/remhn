require "application_system_test_case"

class EquipableStatsTest < ApplicationSystemTestCase
  setup do
    @equipable_stat = equipable_stats(:one)
  end

  test "visiting the index" do
    visit equipable_stats_url
    assert_selector "h1", text: "Equipable stats"
  end

  test "should create equipable stat" do
    visit equipable_stats_url
    click_on "New equipable stat"

    fill_in "Atk", with: @equipable_stat.atk
    fill_in "Crit", with: @equipable_stat.crit
    fill_in "Def", with: @equipable_stat.def
    fill_in "Elem", with: @equipable_stat.elem
    fill_in "Equipable", with: @equipable_stat.equipable_id
    check "Forge" if @equipable_stat.forge
    fill_in "Grade", with: @equipable_stat.grade
    fill_in "Sub grade", with: @equipable_stat.sub_grade
    click_on "Create Equipable stat"

    assert_text "Equipable stat was successfully created"
    click_on "Back"
  end

  test "should update Equipable stat" do
    visit equipable_stat_url(@equipable_stat)
    click_on "Edit this equipable stat", match: :first

    fill_in "Atk", with: @equipable_stat.atk
    fill_in "Crit", with: @equipable_stat.crit
    fill_in "Def", with: @equipable_stat.def
    fill_in "Elem", with: @equipable_stat.elem
    fill_in "Equipable", with: @equipable_stat.equipable_id
    check "Forge" if @equipable_stat.forge
    fill_in "Grade", with: @equipable_stat.grade
    fill_in "Sub grade", with: @equipable_stat.sub_grade
    click_on "Update Equipable stat"

    assert_text "Equipable stat was successfully updated"
    click_on "Back"
  end

  test "should destroy Equipable stat" do
    visit equipable_stat_url(@equipable_stat)
    click_on "Destroy this equipable stat", match: :first

    assert_text "Equipable stat was successfully destroyed"
  end
end
