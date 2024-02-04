class EmptyEquipIcon < ViewComponent::Base
  haml_template <<~HAML
    .empty_equip_icon{ class: classes }
      %img{ src: src, title: title }
  HAML

  attr_reader :subtype, :opts
  attr_reader :equip

  def initialize(subtype, **opts)
    @subtype = subtype
    @opts = opts
    @equip = Equip.new(equip_subtype: subtype)
  end

  def classes
    classes = []
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
