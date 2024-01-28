require "application_system_test_case"

class EquipsTest < ApplicationSystemTestCase
  setup do
    @equip = equips(:one)
  end

  test "visiting the index" do
    visit equips_url
    assert_selector "h1", text: "Equips"
  end

  test "should create equip" do
    visit equips_url
    click_on "New equip"

    fill_in "Atk scheme", with: @equip.atk_scheme
    fill_in "Crit scheme", with: @equip.crit_scheme
    fill_in "Elem scheme", with: @equip.elem_scheme
    fill_in "Element", with: @equip.element_id
    fill_in "Equip subtype", with: @equip.equip_subtype
    fill_in "Equip type", with: @equip.equip_type
    check "Event only" if @equip.event_only
    fill_in "Monster", with: @equip.monster_id
    fill_in "Name", with: @equip.name
    fill_in "Set name", with: @equip.set_name
    check "Starter" if @equip.starter
    fill_in "Unlock", with: @equip.unlock
    click_on "Create Equip"

    assert_text "Equip was successfully created"
    click_on "Back"
  end

  test "should update Equip" do
    visit equip_url(@equip)
    click_on "Edit this equip", match: :first

    fill_in "Atk scheme", with: @equip.atk_scheme
    fill_in "Crit scheme", with: @equip.crit_scheme
    fill_in "Elem scheme", with: @equip.elem_scheme
    fill_in "Element", with: @equip.element_id
    fill_in "Equip subtype", with: @equip.equip_subtype
    fill_in "Equip type", with: @equip.equip_type
    check "Event only" if @equip.event_only
    fill_in "Monster", with: @equip.monster_id
    fill_in "Name", with: @equip.name
    fill_in "Set name", with: @equip.set_name
    check "Starter" if @equip.starter
    fill_in "Unlock", with: @equip.unlock
    click_on "Update Equip"

    assert_text "Equip was successfully updated"
    click_on "Back"
  end

  test "should destroy Equip" do
    visit equip_url(@equip)
    click_on "Destroy this equip", match: :first

    assert_text "Equip was successfully destroyed"
  end
end
