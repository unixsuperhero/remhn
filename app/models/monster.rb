class Monster < ApplicationRecord
  has_many :equips
  has_many :monster_areas
  has_many :areas, through: :monster_areas
  has_many :monster_elements
  has_many :elements, through: :monster_elements
  has_many :monster_weaknesses
  has_many :weaknesses, through: :monster_weaknesses, as: :element

  enum size: { large: 1, small: 2 }
end
