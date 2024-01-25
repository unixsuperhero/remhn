require "application_system_test_case"

class MonsterTerrainsTest < ApplicationSystemTestCase
  setup do
    @monster_terrain = monster_terrains(:one)
  end

  test "visiting the index" do
    visit monster_terrains_url
    assert_selector "h1", text: "Monster terrains"
  end

  test "should create monster terrain" do
    visit monster_terrains_url
    click_on "New monster terrain"

    fill_in "Monster", with: @monster_terrain.monster_id
    fill_in "Terrain", with: @monster_terrain.terrain_id
    click_on "Create Monster terrain"

    assert_text "Monster terrain was successfully created"
    click_on "Back"
  end

  test "should update Monster terrain" do
    visit monster_terrain_url(@monster_terrain)
    click_on "Edit this monster terrain", match: :first

    fill_in "Monster", with: @monster_terrain.monster_id
    fill_in "Terrain", with: @monster_terrain.terrain_id
    click_on "Update Monster terrain"

    assert_text "Monster terrain was successfully updated"
    click_on "Back"
  end

  test "should destroy Monster terrain" do
    visit monster_terrain_url(@monster_terrain)
    click_on "Destroy this monster terrain", match: :first

    assert_text "Monster terrain was successfully destroyed"
  end
end
