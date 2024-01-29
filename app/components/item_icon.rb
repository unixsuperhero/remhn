class ItemIcon < ViewComponent::Base
  haml_template <<~HAML
    .item_icon
      .icon
        %img{ src: src, title: title }
      .text
        .name= item.name
        - if grade_item
          .qty= grade_item.qty
  HAML

  attr_reader :equip, :grade_item, :item

  def initialize(equip, grade_item: nil, item: nil)
    @equip = equip
    @grade_item = grade_item
    @item = item || grade_item.item
  end

  def src
    image_url(icon_path)
  end

  def title
    item.name
  end

  def item_set
    item.item_sets.first
  end

  def icon_path
    subdir =
      case item_set.set_subkey
      when 'l', 'z', 'j1', 'j2', 'k1', 'k2'
        ''
      else
        [item_set.set_key, '/'].join
      end

    ['item/', subdir, item_set.set_subkey, '.png'].join
  end
end
