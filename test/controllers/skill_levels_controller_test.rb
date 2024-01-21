require "test_helper"

class SkillLevelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @skill_level = skill_levels(:one)
  end

  test "should get index" do
    get skill_levels_url
    assert_response :success
  end

  test "should get new" do
    get new_skill_level_url
    assert_response :success
  end

  test "should create skill_level" do
    assert_difference("SkillLevel.count") do
      post skill_levels_url, params: { skill_level: { equipable_id: @skill_level.equipable_id, level_id: @skill_level.level_id, power: @skill_level.power, skill_id: @skill_level.skill_id } }
    end

    assert_redirected_to skill_level_url(SkillLevel.last)
  end

  test "should show skill_level" do
    get skill_level_url(@skill_level)
    assert_response :success
  end

  test "should get edit" do
    get edit_skill_level_url(@skill_level)
    assert_response :success
  end

  test "should update skill_level" do
    patch skill_level_url(@skill_level), params: { skill_level: { equipable_id: @skill_level.equipable_id, level_id: @skill_level.level_id, power: @skill_level.power, skill_id: @skill_level.skill_id } }
    assert_redirected_to skill_level_url(@skill_level)
  end

  test "should destroy skill_level" do
    assert_difference("SkillLevel.count", -1) do
      delete skill_level_url(@skill_level)
    end

    assert_redirected_to skill_levels_url
  end
end
