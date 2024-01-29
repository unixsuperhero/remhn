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
    image_url(icon_path)
  end

  def title
    monster.name
  end

  def icon_path
    ['monster/', monster.key, '.png'].join
  end
end
