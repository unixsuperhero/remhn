require "application_system_test_case"

class TerrainsTest < ApplicationSystemTestCase
  setup do
    @terrain = terrains(:one)
  end

  test "visiting the index" do
    visit terrains_url
    assert_selector "h1", text: "Terrains"
  end

  test "should create terrain" do
    visit terrains_url
    click_on "New terrain"

    fill_in "Name", with: @terrain.name
    click_on "Create Terrain"

    assert_text "Terrain was successfully created"
    click_on "Back"
  end

  test "should update Terrain" do
    visit terrain_url(@terrain)
    click_on "Edit this terrain", match: :first

    fill_in "Name", with: @terrain.name
    click_on "Update Terrain"

    assert_text "Terrain was successfully updated"
    click_on "Back"
  end

  test "should destroy Terrain" do
    visit terrain_url(@terrain)
    click_on "Destroy this terrain", match: :first

    assert_text "Terrain was successfully destroyed"
  end
end
