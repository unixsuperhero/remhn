class ItemForm < ViewComponent::Base
  haml_template <<~HAML
    .item_form{ 'data-controller': 'item-form' }
      - items.each do |item|
        .item_row
          = render ItemIcon.new(item)
          %input{ type: :text, 'data-data_type': 'count', 'data-item_id': item.id, 'data-action': 'blur->item-form#updateItem' }/
          %input{ type: :text, 'data-data_type': 'position', 'data-item_id': item.id, 'data-action': 'blur->item-form#updateItem' }/
  HAML

  def items
    @items ||= Item.order(:rarity, :name).all
  end
end
