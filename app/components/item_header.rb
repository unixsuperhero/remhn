class ItemHeader < ViewComponent::Base
  haml_template <<~HAML
    .item_header
      .icon
        = render ItemIcon.new(item, icon_only: true)
      .text
        .name= item.name
        .rarity= rarity
  HAML

  attr_reader :item

  def initialize(item)
    @item = item
  end

  def rarity
    num =
      if item.rarity == 0
        '---'
      else
        item.rarity
      end
    sprintf('Rarity %s', num)
  end
end
