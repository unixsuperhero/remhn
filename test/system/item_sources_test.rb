require "application_system_test_case"

class ItemSourcesTest < ApplicationSystemTestCase
  setup do
    @item_source = item_sources(:one)
  end

  test "visiting the index" do
    visit item_sources_url
    assert_selector "h1", text: "Item sources"
  end

  test "should create item source" do
    visit item_sources_url
    click_on "New item source"

    fill_in "Item", with: @item_source.item_id
    fill_in "Source", with: @item_source.source_id
    fill_in "Source type", with: @item_source.source_type
    fill_in "Stars", with: @item_source.stars
    click_on "Create Item source"

    assert_text "Item source was successfully created"
    click_on "Back"
  end

  test "should update Item source" do
    visit item_source_url(@item_source)
    click_on "Edit this item source", match: :first

    fill_in "Item", with: @item_source.item_id
    fill_in "Source", with: @item_source.source_id
    fill_in "Source type", with: @item_source.source_type
    fill_in "Stars", with: @item_source.stars
    click_on "Update Item source"

    assert_text "Item source was successfully updated"
    click_on "Back"
  end

  test "should destroy Item source" do
    visit item_source_url(@item_source)
    click_on "Destroy this item source", match: :first

    assert_text "Item source was successfully destroyed"
  end
end
