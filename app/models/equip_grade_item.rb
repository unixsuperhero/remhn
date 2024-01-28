class EquipGradeItem < ApplicationRecord
  belongs_to :equip
  belongs_to :equip_grade
  belongs_to :item
end
