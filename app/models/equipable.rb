class Equipable < ApplicationRecord
  enum group: { weapon: 1, armor: 2 }
  enum sub_group: {
    shield_sword:       1,
    great_sword:        2,
    hammer:             3,
    long_sword:         4,
    light_gun:          5,
    bow:                6,
    dual_blades:        7,
    lance:              8,
    helm:               9,
    mail:               10,
    gloves:             11,
    belt:               12,
    greaves:            13,
  }

  belongs_to :monster, optional: true
  belongs_to :element, optional: true

  has_many :equipable_stats
  has_many :item_stats

  scope :weapons, -> { where(group: :weapon) }
  scope :armors, -> { where(group: :armor) }

end
