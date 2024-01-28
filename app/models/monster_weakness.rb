class MonsterWeakness < ApplicationRecord
  belongs_to :monster
  belongs_to :element
end
