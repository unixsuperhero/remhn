class Terrain < ApplicationRecord
  has_many :monster_terrains
  has_many :monsters, through: :monster_terrains
end
