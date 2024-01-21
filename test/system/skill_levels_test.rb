require "application_system_test_case"

class SkillLevelsTest < ApplicationSystemTestCase
  setup do
    @skill_level = skill_levels(:one)
  end

  test "visiting the index" do
    visit skill_levels_url
    assert_selector "h1", text: "Skill levels"
  end

  test "should create skill level" do
    visit skill_levels_url
    click_on "New skill level"

    fill_in "Equipable", with: @skill_level.equipable_id
    fill_in "Level", with: @skill_level.level_id
    fill_in "Power", with: @skill_level.power
    fill_in "Skill", with: @skill_level.skill_id
    click_on "Create Skill level"

    assert_text "Skill level was successfully created"
    click_on "Back"
  end

  test "should update Skill level" do
    visit skill_level_url(@skill_level)
    click_on "Edit this skill level", match: :first

    fill_in "Equipable", with: @skill_level.equipable_id
    fill_in "Level", with: @skill_level.level_id
    fill_in "Power", with: @skill_level.power
    fill_in "Skill", with: @skill_level.skill_id
    click_on "Update Skill level"

    assert_text "Skill level was successfully updated"
    click_on "Back"
  end

  test "should destroy Skill level" do
    visit skill_level_url(@skill_level)
    click_on "Destroy this skill level", match: :first

    assert_text "Skill level was successfully destroyed"
  end
end
