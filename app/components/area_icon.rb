class AreaIcon < ViewComponent::Base
  haml_template <<~HAML
    .area_icon
      %img{ src: src, title: title }/
  HAML

  attr_reader :area

  def initialize(area)
    @area = area
  end

  def src
    image_url(image_path)
  end

  def image_path
    sprintf('areas/%s.png', area.name.downcase)
  end

  def title
    area.name
  end
end
