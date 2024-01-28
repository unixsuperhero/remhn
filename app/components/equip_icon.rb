class EquipIcon < ViewComponent::Base
  haml_template <<~HAML
    .equip_icon{ class: classes }
      %img{ src: image_url(src), title: title }
  HAML

  attr_reader :equip, :selected

  def initialize(equip, selected=false)
    @equip, @selected = equip, selected
  end

  def classes
    selected ? 'selected' : ''
  end

  def src
    'part/%s.png' % equip.equip_subtype
  end

  def title
    equip.display_title
  end
end
