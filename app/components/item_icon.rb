class ItemIcon < ViewComponent::Base
  haml_template <<~HAML
    .item_icon
      .qty
        = grade_item.qty
      .icon
        %img{ src: src, title: title }
      .text
        = item.name
  HAML

  attr_reader :equip, :grade_item, :item

  def initialize(equip, grade_item)
    @equip = equip
    @grade_item = grade_item
    @item = grade_item.item
  end

  def src
    image_url(icon_path)
  end

  def title
    item.name
  end

  def icon_path
    EquipItemIcon.path_for(equip, item)
  end
end
