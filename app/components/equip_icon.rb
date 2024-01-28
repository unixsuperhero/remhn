class EquipIcon < ViewComponent::Base
  haml_template <<~HAML
    .equip_icon{ class: classes }
      %img{ src: src, title: title }
  HAML

  attr_reader :equip, :selected

  def initialize(equip, selected=false)
    @equip, @selected = equip, selected
  end

  def classes
    selected ? 'selected' : ''
  end

  def src
    url = 'part/%s.png' % equip.equip_subtype
    image_url(url)
  end

  def title
    equip.display_title
  end
end
