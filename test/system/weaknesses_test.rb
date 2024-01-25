require "application_system_test_case"

class WeaknessesTest < ApplicationSystemTestCase
  setup do
    @weakness = weaknesses(:one)
  end

  test "visiting the index" do
    visit weaknesses_url
    assert_selector "h1", text: "Weaknesses"
  end

  test "should create weakness" do
    visit weaknesses_url
    click_on "New weakness"

    fill_in "Element", with: @weakness.element_id
    fill_in "Monster", with: @weakness.monster_id
    click_on "Create Weakness"

    assert_text "Weakness was successfully created"
    click_on "Back"
  end

  test "should update Weakness" do
    visit weakness_url(@weakness)
    click_on "Edit this weakness", match: :first

    fill_in "Element", with: @weakness.element_id
    fill_in "Monster", with: @weakness.monster_id
    click_on "Update Weakness"

    assert_text "Weakness was successfully updated"
    click_on "Back"
  end

  test "should destroy Weakness" do
    visit weakness_url(@weakness)
    click_on "Destroy this weakness", match: :first

    assert_text "Weakness was successfully destroyed"
  end
end
