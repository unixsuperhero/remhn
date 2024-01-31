class MonsterHeader < ViewComponent::Base
  haml_template <<~HAML
    .monster_header
      .icon
        %img{ src: image_url(src), title: title }/
      .text
        .name= monster.name
        .size= monster.size.titleize
  HAML

  attr_reader :monster, :selected

  def initialize(monster)
    @monster = monster
  end

  def src
    'monster/%s.png' % monster.key
  end

  def title
    monster.name
  end
end
