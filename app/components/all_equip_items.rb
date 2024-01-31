class AllEquipItems < ViewComponent::Base
  haml_template <<~HAML
    .all_equip_items
      - all_items.each do |i|
        .equip_item
          = render ItemBadge.new(i)

  HAML

  attr_reader :equip, :selected

  def initialize(equip)
    @equip = equip
  end

  def all_items
    EquipTable.for(equip).values.compact
  end
end
