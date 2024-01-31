class ItemForm < ViewComponent::Base
  haml_template <<~HAML
    .item_form{ 'data-controller': 'item-form' }
      - items.each do |item|
        .item_row{style: 'display: flex; margin-bottom: 8px; line-height: 1;'}
          %img{ src: src(item), title: title(item), style: 'width: 32px; height: 32px; margin-right: 12px;' }
          %div{style: 'width: 200px; transform: translateY(8px);'}= item.name
          %input{ type: :text, 'data-item_id': item.id, 'data-action': 'blur->item-form#updateItem' }/
  HAML

  def items
    @items ||= Item.order(:rarity, :sort_order).all
  end

  def src(item)
    image_url(icon_path(item))
  end

  def title(item)
    item.name
  end

  def item_set(item)
    item.item_sets.first
  end

  def icon_path(item)
    temp_item_set = item_set(item)
    subdir =
      case temp_item_set.set_subkey
      when 'l', 'z', 'j1', 'j2', 'k1', 'k2'
        ''
      else
        [temp_item_set.set_key, '/'].join
      end

    ['item/', subdir, temp_item_set.set_subkey, '.png'].join
  end
end
