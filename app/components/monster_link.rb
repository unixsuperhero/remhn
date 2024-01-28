class MonsterLink < ViewComponent::Base
  haml_template <<~HAML
    = link_to monster_path(monster) do
      = content
  HAML

  attr_reader :monster

  def initialize(monster)
    @monster = monster
  end
end
