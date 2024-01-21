require "test_helper"

class EquipablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equipable = equipables(:one)
  end

  test "should get index" do
    get equipables_url
    assert_response :success
  end

  test "should get new" do
    get new_equipable_url
    assert_response :success
  end

  test "should create equipable" do
    assert_difference("Equipable.count") do
      post equipables_url, params: { equipable: { group: @equipable.group, monster_id: @equipable.monster_id, subgroup: @equipable.subgroup } }
    end

    assert_redirected_to equipable_url(Equipable.last)
  end

  test "should show equipable" do
    get equipable_url(@equipable)
    assert_response :success
  end

  test "should get edit" do
    get edit_equipable_url(@equipable)
    assert_response :success
  end

  test "should update equipable" do
    patch equipable_url(@equipable), params: { equipable: { group: @equipable.group, monster_id: @equipable.monster_id, subgroup: @equipable.subgroup } }
    assert_redirected_to equipable_url(@equipable)
  end

  test "should destroy equipable" do
    assert_difference("Equipable.count", -1) do
      delete equipable_url(@equipable)
    end

    assert_redirected_to equipables_url
  end
end
