class Item < ApplicationRecord
  has_many :item_sources
  has_many :sources, through: :item_sources
  has_many :item_sets
  has_many :sets, class_name: 'ItemSet'
end
