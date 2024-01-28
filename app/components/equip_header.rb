class EquipHeader < ViewComponent::Base
  haml_template <<~HAML
    .equip_header
      .icon
        %img{ src: image_url(src), title: title }/
      .name= equip.set_name
      -#.hover= title
  HAML

  attr_reader :equip, :selected

  def initialize(equip)
    @equip = equip
  end

  def src
    'part/%s.png' % equip.equip_subtype
  end

  def title
    equip.display_title
  end
end
