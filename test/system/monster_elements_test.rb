require "application_system_test_case"

class MonsterElementsTest < ApplicationSystemTestCase
  setup do
    @monster_element = monster_elements(:one)
  end

  test "visiting the index" do
    visit monster_elements_url
    assert_selector "h1", text: "Monster elements"
  end

  test "should create monster element" do
    visit monster_elements_url
    click_on "New monster element"

    fill_in "Element", with: @monster_element.element_id
    fill_in "Monster", with: @monster_element.monster_id
    click_on "Create Monster element"

    assert_text "Monster element was successfully created"
    click_on "Back"
  end

  test "should update Monster element" do
    visit monster_element_url(@monster_element)
    click_on "Edit this monster element", match: :first

    fill_in "Element", with: @monster_element.element_id
    fill_in "Monster", with: @monster_element.monster_id
    click_on "Update Monster element"

    assert_text "Monster element was successfully updated"
    click_on "Back"
  end

  test "should destroy Monster element" do
    visit monster_element_url(@monster_element)
    click_on "Destroy this monster element", match: :first

    assert_text "Monster element was successfully destroyed"
  end
end
