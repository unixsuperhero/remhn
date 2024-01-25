class Element < ApplicationRecord
  has_many :monster_elements
  has_many :monsters, through: :monster_elements
end
