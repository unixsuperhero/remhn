require "test_helper"

class MonsterElementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @monster_element = monster_elements(:one)
  end

  test "should get index" do
    get monster_elements_url
    assert_response :success
  end

  test "should get new" do
    get new_monster_element_url
    assert_response :success
  end

  test "should create monster_element" do
    assert_difference("MonsterElement.count") do
      post monster_elements_url, params: { monster_element: { element_id: @monster_element.element_id, monster_id: @monster_element.monster_id } }
    end

    assert_redirected_to monster_element_url(MonsterElement.last)
  end

  test "should show monster_element" do
    get monster_element_url(@monster_element)
    assert_response :success
  end

  test "should get edit" do
    get edit_monster_element_url(@monster_element)
    assert_response :success
  end

  test "should update monster_element" do
    patch monster_element_url(@monster_element), params: { monster_element: { element_id: @monster_element.element_id, monster_id: @monster_element.monster_id } }
    assert_redirected_to monster_element_url(@monster_element)
  end

  test "should destroy monster_element" do
    assert_difference("MonsterElement.count", -1) do
      delete monster_element_url(@monster_element)
    end

    assert_redirected_to monster_elements_url
  end
end
