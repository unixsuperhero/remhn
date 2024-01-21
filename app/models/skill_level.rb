class SkillLevel < ApplicationRecord
  belongs_to :skill
  belongs_to :level
  belongs_to :equipable
end
