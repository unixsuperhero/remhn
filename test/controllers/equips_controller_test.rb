require "test_helper"

class EquipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equip = equips(:one)
  end

  test "should get index" do
    get equips_url
    assert_response :success
  end

  test "should get new" do
    get new_equip_url
    assert_response :success
  end

  test "should create equip" do
    assert_difference("Equip.count") do
      post equips_url, params: { equip: { atk_scheme: @equip.atk_scheme, crit_scheme: @equip.crit_scheme, elem_scheme: @equip.elem_scheme, element_id: @equip.element_id, equip_subtype: @equip.equip_subtype, equip_type: @equip.equip_type, event_only: @equip.event_only, monster_id: @equip.monster_id, name: @equip.name, set_name: @equip.set_name, starter: @equip.starter, unlock: @equip.unlock } }
    end

    assert_redirected_to equip_url(Equip.last)
  end

  test "should show equip" do
    get equip_url(@equip)
    assert_response :success
  end

  test "should get edit" do
    get edit_equip_url(@equip)
    assert_response :success
  end

  test "should update equip" do
    patch equip_url(@equip), params: { equip: { atk_scheme: @equip.atk_scheme, crit_scheme: @equip.crit_scheme, elem_scheme: @equip.elem_scheme, element_id: @equip.element_id, equip_subtype: @equip.equip_subtype, equip_type: @equip.equip_type, event_only: @equip.event_only, monster_id: @equip.monster_id, name: @equip.name, set_name: @equip.set_name, starter: @equip.starter, unlock: @equip.unlock } }
    assert_redirected_to equip_url(@equip)
  end

  test "should destroy equip" do
    assert_difference("Equip.count", -1) do
      delete equip_url(@equip)
    end

    assert_redirected_to equips_url
  end
end
