class EquipLink < ViewComponent::Base
  haml_template <<~HAML
    = link_to equip_path(equip) do
      = content
  HAML

  attr_reader :equip

  def initialize(equip)
    @equip = equip
  end
end
