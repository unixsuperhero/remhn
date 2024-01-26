class ItemStat < ApplicationRecord
  belongs_to :item
  belongs_to :equipable_stat
  belongs_to :equipable
  belongs_to :monster, optional: true
end
