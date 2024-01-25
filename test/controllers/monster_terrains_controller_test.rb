require "test_helper"

class MonsterTerrainsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @monster_terrain = monster_terrains(:one)
  end

  test "should get index" do
    get monster_terrains_url
    assert_response :success
  end

  test "should get new" do
    get new_monster_terrain_url
    assert_response :success
  end

  test "should create monster_terrain" do
    assert_difference("MonsterTerrain.count") do
      post monster_terrains_url, params: { monster_terrain: { monster_id: @monster_terrain.monster_id, terrain_id: @monster_terrain.terrain_id } }
    end

    assert_redirected_to monster_terrain_url(MonsterTerrain.last)
  end

  test "should show monster_terrain" do
    get monster_terrain_url(@monster_terrain)
    assert_response :success
  end

  test "should get edit" do
    get edit_monster_terrain_url(@monster_terrain)
    assert_response :success
  end

  test "should update monster_terrain" do
    patch monster_terrain_url(@monster_terrain), params: { monster_terrain: { monster_id: @monster_terrain.monster_id, terrain_id: @monster_terrain.terrain_id } }
    assert_redirected_to monster_terrain_url(@monster_terrain)
  end

  test "should destroy monster_terrain" do
    assert_difference("MonsterTerrain.count", -1) do
      delete monster_terrain_url(@monster_terrain)
    end

    assert_redirected_to monster_terrains_url
  end
end
