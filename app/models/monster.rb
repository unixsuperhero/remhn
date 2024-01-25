class Monster < ApplicationRecord
  has_many :monster_terrains
  has_many :monster_elements

  has_many :terrains, through: :monster_terrains
  has_many :equipables
  has_many :elements, through: :monster_elements
  has_many :weaknesses

  enum size: { small: 1, large: 2 }
  enum poison: { white: 1, yellow: 2, red: 3 }, _scopes: false, _prefix: true
  enum paralysis: { white: 1, yellow: 2, red: 3 }, _scopes: false, _prefix: true
  enum stun: { white: 1, yellow: 2, red: 3 }, _scopes: false, _prefix: true
  enum sleep: { white: 1, yellow: 2, red: 3 }, _scopes: false, _prefix: true

  def weak_elements
    Element.where(id: weaknesses.pluck(:element_id))
  end

  def strong_elements
    elements
  end
end
