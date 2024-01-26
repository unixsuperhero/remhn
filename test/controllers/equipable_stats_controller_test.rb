require "test_helper"

class EquipableStatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @equipable_stat = equipable_stats(:one)
  end

  test "should get index" do
    get equipable_stats_url
    assert_response :success
  end

  test "should get new" do
    get new_equipable_stat_url
    assert_response :success
  end

  test "should create equipable_stat" do
    assert_difference("EquipableStat.count") do
      post equipable_stats_url, params: { equipable_stat: { atk: @equipable_stat.atk, crit: @equipable_stat.crit, def: @equipable_stat.def, elem: @equipable_stat.elem, equipable_id: @equipable_stat.equipable_id, forge: @equipable_stat.forge, grade: @equipable_stat.grade, sub_grade: @equipable_stat.sub_grade } }
    end

    assert_redirected_to equipable_stat_url(EquipableStat.last)
  end

  test "should show equipable_stat" do
    get equipable_stat_url(@equipable_stat)
    assert_response :success
  end

  test "should get edit" do
    get edit_equipable_stat_url(@equipable_stat)
    assert_response :success
  end

  test "should update equipable_stat" do
    patch equipable_stat_url(@equipable_stat), params: { equipable_stat: { atk: @equipable_stat.atk, crit: @equipable_stat.crit, def: @equipable_stat.def, elem: @equipable_stat.elem, equipable_id: @equipable_stat.equipable_id, forge: @equipable_stat.forge, grade: @equipable_stat.grade, sub_grade: @equipable_stat.sub_grade } }
    assert_redirected_to equipable_stat_url(@equipable_stat)
  end

  test "should destroy equipable_stat" do
    assert_difference("EquipableStat.count", -1) do
      delete equipable_stat_url(@equipable_stat)
    end

    assert_redirected_to equipable_stats_url
  end
end
