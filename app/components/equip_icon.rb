class EquipIcon < ViewComponent::Base
  haml_template <<~HAML
    .equip_icon{ class: classes }
      %img{ src: src, title: title }
  HAML

  attr_reader :equip, :selected
  attr_reader :opts

  def initialize(equip, selected=false, **opts)
    @equip, @selected = equip, selected
    @opts = opts
  end

  def classes
    classes = []
    classes << 'selected' if selected
    classes << 'small' if opts[:small]

    classes.join(' ')
  end

  def src
    image_url(icon_path)
  end

  def title
    equip.display_title
  end

  def icon_path
    ['part/', equip.equip_subtype, '.png'].join
  end
end
