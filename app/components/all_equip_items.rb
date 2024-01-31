class AllEquipItems < ViewComponent::Base
  haml_template <<~HAML
    .all_equip_items
      - all_items.each do |i|
        = render ItemBadge.new(i)

  HAML

  attr_reader :equip, :selected

  def initialize(equip)
    @equip = equip
  end

  def all_items
    EquipTable
      .for(equip)
      .values
      .compact
      .sort_by(&:sort_order)
  end
end
