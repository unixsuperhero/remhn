class Item < ApplicationRecord
  TYPES = {
    ore: 1,
    bone: 2,
    vegetation: 3,
    monster: 4,
    quest: 5,
    money: 6,
  }

  has_many :item_sources
  has_many :sources, through: :item_sources

  enum item_type: TYPES
end
