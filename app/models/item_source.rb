class ItemSource < ApplicationRecord
  belongs_to :item
  belongs_to :source, polymorphic: true
end
