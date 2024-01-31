class ItemBadge < ViewComponent::Base
  haml_template <<~HAML
    .item_badge{ class: rarity_class }
      .icon
        = render ItemLink.new(item) do
          = render ItemIcon.new(item)
      .text
        = render ItemLink.new(item) do
          .name= item.name
        - if grade_item
          .qty= grade_item.qty
  HAML

  attr_reader :item, :grade_item

  def initialize(item, grade_item: nil)
    @item = item
    @grade_item = grade_item
  end

  def rarity_class
    ['r', item.rarity].join
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
