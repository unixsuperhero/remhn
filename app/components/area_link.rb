class AreaLink < ViewComponent::Base
  haml_template <<~HAML
    .area_link
      = link_to area_path(area) do
        = content
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
