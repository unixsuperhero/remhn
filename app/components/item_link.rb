class ItemLink < ViewComponent::Base
  haml_template <<~HAML
    .item_link
      = link_to item_path(item) do
        = content
  HAML

  attr_reader :item

  def initialize(item)
    @item = item
  end
end
