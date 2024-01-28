class EquipGrade < ApplicationRecord
  belongs_to :equip

  has_many :equip_grade_items
  has_many :items, through: :equip_grade_items
end
