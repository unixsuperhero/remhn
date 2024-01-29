class AllEquipItems < ViewComponent::Base
  haml_template <<~HAML
    .all_equip_items
      - all_items.each do |i|
        = render ItemIcon.new(i, item: i)

  HAML

  attr_reader :equip, :selected

  def initialize(equip)
    @equip = equip
  end

  def src
    'part/%s.png' % equip.equip_subtype
  end

  def title
    equip.display_title
  end

  def all_items
    EquipTable.for(equip).values.compact
  end
end
