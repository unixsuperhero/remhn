class Weakness < ApplicationRecord
  belongs_to :monster
  belongs_to :element
end
