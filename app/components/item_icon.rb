class ItemIcon < ViewComponent::Base
  haml_template <<~HAML
    .item_icon{ class: rarity_class }
      %img{ src: src, title: title }
  HAML

  attr_reader :item

  def initialize(item, icon_only: false)
    @item = item
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
