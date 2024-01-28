class Item < ApplicationRecord
  has_many :item_sources
  has_many :sources, through: :item_sources
end
