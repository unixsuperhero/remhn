class ForgeItem < ApplicationRecord
  belongs_to :equipable
  belongs_to :level
  belongs_to :item
end
