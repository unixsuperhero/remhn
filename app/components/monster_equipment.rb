class MonsterEquipment < ViewComponent::Base
  haml_template <<~HAML
    .monster_equipment
      = render MonsterLink.new(monster) do
        = render MonsterIcon.new(monster)
      .equip_icons
        .icon_list
          - monster.equips.weapons.each.with_index do |equip, i|
            = render EquipLink.new(equip) do
              = render EquipIcon.new(equip, selected?(equip))
          - monster.equips.armors.each do |equip|
            = render EquipLink.new(equip) do
              = render EquipIcon.new(equip, selected?(equip))
  HAML

  attr_reader :monster, :selected

  def initialize(monster, selected=nil)
    @monster = monster
    @selected = selected
  end

  def selected?(equip)
    selected == equip
  end
end
