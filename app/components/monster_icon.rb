class MonsterIcon < ViewComponent::Base
  haml_template <<~HAML
    .monster_icon{ class: classes }
      %img{ src: src, title: title }
      -#.hover= title
  HAML

  attr_reader :monster, :selected

  def initialize(monster, selected=false)
    @monster, @selected = monster, selected
  end

  def classes
    selected ? 'selected' : ''
  end

  def src
    url = 'monster/%s.png' % monster.key
    image_url(url)
  end

  def title
    monster.name
  end
end
