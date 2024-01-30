class MonsterSummary < ViewComponent::Base
  haml_template <<~HAML
    .monster_summary
      .icon
        = render MonsterLink.new(monster) do
          %img{ src: image_url(src), title: title }/
      .text
        .name
          = render MonsterLink.new(monster) do
            = monster.name
        .size= monster.size
        .equipables
          - equips.each do |equip|
            = render EquipLink.new(equip) do
              = render EquipIcon.new(equip, small: true)
  HAML

  attr_reader :monster

  def initialize(monster)
    @monster = monster
  end

  def src
    sprintf('monster/%s.png', monster.key)
  end

  def title
    monster.name
  end

  def equips
    monster.equips.order(:equip_type, :equip_subtype)
  end
end
