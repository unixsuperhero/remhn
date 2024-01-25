require "test_helper"

class WeaknessesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @weakness = weaknesses(:one)
  end

  test "should get index" do
    get weaknesses_url
    assert_response :success
  end

  test "should get new" do
    get new_weakness_url
    assert_response :success
  end

  test "should create weakness" do
    assert_difference("Weakness.count") do
      post weaknesses_url, params: { weakness: { element_id: @weakness.element_id, monster_id: @weakness.monster_id } }
    end

    assert_redirected_to weakness_url(Weakness.last)
  end

  test "should show weakness" do
    get weakness_url(@weakness)
    assert_response :success
  end

  test "should get edit" do
    get edit_weakness_url(@weakness)
    assert_response :success
  end

  test "should update weakness" do
    patch weakness_url(@weakness), params: { weakness: { element_id: @weakness.element_id, monster_id: @weakness.monster_id } }
    assert_redirected_to weakness_url(@weakness)
  end

  test "should destroy weakness" do
    assert_difference("Weakness.count", -1) do
      delete weakness_url(@weakness)
    end

    assert_redirected_to weaknesses_url
  end
end
