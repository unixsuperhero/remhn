class MonsterEquipment < ViewComponent::Base
  haml_template <<~HAML
    .monster_equipment
      = render MonsterLink.new(monster) do
        = render MonsterIcon.new(monster)
      .equip_icons
        .icon_list
          - 1.upto(13).each do |subtype|
            - if equip = equips.find_by(equip_subtype: subtype)
              = render EquipLink.new(equip) do
                = render EquipIcon.new(equip, selected?(equip))
            - else
              = render EmptyEquipIcon.new(subtype)
  HAML

  attr_reader :monster, :selected

  def initialize(monster, selected=nil)
    @monster = monster
    @selected = selected
  end

  def selected?(equip)
    selected == equip
  end

  def equips
    monster.equips.order(:equip_subtype)
  end
end
