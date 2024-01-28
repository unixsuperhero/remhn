class MonsterEquipment < ViewComponent::Base
  haml_template <<~HAML
    .monster_equipment
      = render MonsterLink.new(monster) do
        = render MonsterIcon.new(monster)
      .part_icons
        .icon_list
          - monster.equips.weapons.each.with_index do |part, i|
            = render EquipLink.new(part) do
              = render EquipIcon.new(part, part_selected?(part))
          - monster.equips.armors.each do |part|
            = render EquipLink.new(part) do
              = render EquipIcon.new(part, part_selected?(part))
  HAML

  attr_reader :monster, :selected

  def initialize(monster, selected=nil)
    @monster = monster
    @selected = selected
  end

  def monster_icon
    'monster/%s.png' % monster.key
  end

  def part_selected?(part)
    selected == part
  end

  def part_icon(weapon)
    'part/%s.png' % weapon.equip_subtype
  end
end
