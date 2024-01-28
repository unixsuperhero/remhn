class MonsterWeakness < ApplicationRecord
  belongs_to :monster
  belongs_to :element
  belongs_to :weakness, class_name: 'Element', foreign_key: 'element_id'
end
