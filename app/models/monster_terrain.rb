class MonsterTerrain < ApplicationRecord
  belongs_to :monster
  belongs_to :terrain
end
