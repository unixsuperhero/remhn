class EquipableStat < ApplicationRecord
  belongs_to :equipable

  has_many :item_stats
end
